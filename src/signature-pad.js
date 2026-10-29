/*
 * Signature Pad item plug-in for Oracle APEX (TechRevX, www.techrevx.com)
 *
 * techrevx.signaturePad.init( itemName, options, initFn ) is called by the render procedure. The item's value lives in
 * the hidden input #<itemName>; the pad is built in #<itemName>_sig around it. Drawing uses signature_pad (MIT).
 *
 * The value is an image data URL. What the pad shows is painted from three layers, in this order:
 *   base   a loaded value (image), until Clear or Undo removes it
 *   typed  a typed name, drawn in a handwriting font (replaces drawing)
 *   pad    the strokes drawn with signature_pad
 * The canvas itself stays transparent; the paper color is CSS, and added to the image only when saving.
 *
 * apex.item( name ): getValue(), setValue( dataUrl ), isEmpty(), enable(), disable(), setFocusTo().
 * techrevx.signaturePad.get( name ).setPen( { color: "#b3261e", width: "bold" } ) changes the pen from code.
 * Events on the item: change, tx-signaturepad-begin, tx-signaturepad-clear.
 */
( function( $, apex ) {
    "use strict";

    const ns = window.techrevx = window.techrevx || {},
        WIDTHS = { fine: [ 0.4, 1.6 ], medium: [ 0.7, 2.6 ], bold: [ 1.2, 3.8 ] },
        SCRIPT_FONT = "\"Segoe Script\", \"Brush Script MT\", \"Snell Roundhand\", \"Apple Chancery\", \"URW Chancery L\", cursive",
        LINE_AT = 0.72, // signature line, as a share of the pad height; the CSS uses the same value
        DATA_URL = /^data:image\/(png|jpeg|svg\+xml);base64,[A-Za-z0-9+/=]+$/;

    function el( tag, cls, text ) {
        const e = document.createElement( tag );
        if ( cls ) { e.className = cls; }
        if ( text != null ) { e.textContent = text; }
        return e;
    }

    function button( cls, icon, label ) {
        const b = el( "button", "tx-Sig-btn " + cls ),
            i = el( "span", "fa " + icon );
        b.type = "button";
        i.setAttribute( "aria-hidden", "true" );
        b.append( i, el( "span", null, label ) );
        return b;
    }

    // smallest rectangle holding all non-transparent pixels, or null
    function inkBounds( canvas ) {
        const w = canvas.width, h = canvas.height;
        if ( !w || !h ) { return null; }
        const d = canvas.getContext( "2d" ).getImageData( 0, 0, w, h ).data;
        let x1 = w, y1 = h, x2 = -1, y2 = -1;
        for ( let y = 0; y < h; y++ ) {
            for ( let x = 0; x < w; x++ ) {
                if ( d[ ( y * w + x ) * 4 + 3 ] > 8 ) {
                    if ( x < x1 ) { x1 = x; }
                    if ( x > x2 ) { x2 = x; }
                    if ( y < y1 ) { y1 = y; }
                    if ( y > y2 ) { y2 = y; }
                }
            }
        }
        return x2 < 0 ? null : { x: x1, y: y1, w: x2 - x1 + 1, h: y2 - y1 + 1 };
    }

    class Pad {
        constructor( itemName, options ) {
            this.name = itemName;
            this.o = options;
            this.input = document.getElementById( itemName );
            this.wrap = document.getElementById( itemName + "_sig" );
            this.features = String( options.features || "" ).split( ":" );
            this.typed = "";
            this.base = null;
            this.disabled = false;
            this.cw = this.ch = 0;
            this.build();

            const w = WIDTHS[ options.penWidth ] || WIDTHS.medium;
            this.pad = new window.SignaturePad( this.canvas, Object.assign( {
                penColor: options.penColor || "#1b2a4a",
                minWidth: w[ 0 ],
                maxWidth: w[ 1 ],
                backgroundColor: "rgba(0,0,0,0)",
                // cropping reads the pixels back after each stroke
                canvasContextOptions: { willReadFrequently: true }
            }, options.padOptions ) );
            this.pad.addEventListener( "beginStroke", () => {
                if ( this.typed ) { this.setTyped( "" ); this.pad.clear(); }
                if ( !this.pad.toData().length ) { this.ref = { w: this.cw, h: this.ch }; }
                this.wrap.classList.add( "is-drawing" );
                if ( this.placeholder ) { this.placeholder.hidden = true; }
                apex.event.trigger( this.input, "tx-signaturepad-begin" );
            } );
            this.pad.addEventListener( "endStroke", () => {
                this.wrap.classList.remove( "is-drawing" );
                this.save();
            } );
            this.penWidth = WIDTHS[ options.penWidth ] ? options.penWidth : "medium";
            this.setPen( {} );

            this.resize();
            if ( window.ResizeObserver ) { new ResizeObserver( () => this.resize() ).observe( this.area ); }
            if ( this.input.value ) { this.load( this.input.value ); }
            this.update();
        }

        build() {
            const o = this.o, label = document.getElementById( this.name + "_LABEL" );
            this.area = el( "div", "tx-Sig-area" );
            if ( o.sizing === "fixed" ) {
                this.area.style.height = ( o.height || 200 ) + "px";
            } else {
                // Height is the maximum; narrower pads keep a 2:1 shape (CSS sets the minimum)
                this.area.classList.add( "tx-Sig-area--responsive" );
                this.area.style.maxHeight = ( o.height || 200 ) + "px";
            }
            if ( o.background ) { this.area.style.setProperty( "--tx-sig-paper", o.background ); }
            this.canvas = el( "canvas", "tx-Sig-canvas" );
            this.canvas.setAttribute( "role", "img" );
            this.canvas.tabIndex = -1;
            this.canvas.setAttribute( "aria-label", ( label ? label.textContent.trim() + ": " : "" ) + "signature pad. Draw with a mouse, finger or pen"
                + ( this.has( "type" ) ? ", or choose Type instead." : "." ) );
            this.area.append( this.canvas );
            if ( this.has( "line" ) ) {
                const line = el( "div", "tx-Sig-line" );
                line.setAttribute( "aria-hidden", "true" );
                this.area.append( line );
                this.area.classList.add( "has-line" );
            }
            if ( o.placeholder ) {
                this.placeholder = el( "div", "tx-Sig-placeholder", o.placeholder );
                this.placeholder.setAttribute( "aria-hidden", "true" );
                this.area.append( this.placeholder );
            }

            const bar = el( "div", "tx-Sig-bar" );
            if ( this.has( "type" ) ) {
                this.typeBtn = button( "tx-Sig-typeBtn", "fa-keyboard-o", "Type instead" );
                this.typeBtn.setAttribute( "aria-expanded", "false" );
                this.typeBtn.addEventListener( "click", () => this.toggleType() );
                bar.append( this.typeBtn );
            }
            if ( this.has( "pen" ) ) { bar.append( this.buildPen() ); }
            const actions = el( "div", "tx-Sig-actions" );
            if ( this.has( "undo" ) ) {
                this.undoBtn = button( "tx-Sig-undo", "fa-undo", "Undo" );
                this.undoBtn.addEventListener( "click", () => this.undo() );
                actions.append( this.undoBtn );
            }
            if ( this.has( "clear" ) ) {
                this.clearBtn = button( "tx-Sig-clear", "fa-times", "Clear" );
                this.clearBtn.addEventListener( "click", () => this.clear( true ) );
                actions.append( this.clearBtn );
            }
            if ( actions.children.length ) { bar.append( actions ); }

            this.wrap.prepend( this.area );
            if ( bar.children.length ) { this.area.after( bar ); }
            if ( this.typeBtn ) {
                this.typeRow = el( "div", "tx-Sig-typeRow" );
                this.typeRow.hidden = true;
                this.typeInput = el( "input", "tx-Sig-typeInput" );
                this.typeInput.type = "text";
                this.typeInput.maxLength = 60;
                this.typeInput.autocomplete = "name";
                this.typeInput.placeholder = "Type your full name";
                this.typeInput.setAttribute( "aria-label", "Type your name to sign" );
                this.typeInput.id = this.name + "_typed";
                this.typeInput.addEventListener( "input", () => {
                    this.base = null;
                    this.setTyped( this.typeInput.value.trim(), true );
                    this.repaint( [] );
                    this.update();
                    clearTimeout( this.typeTimer );
                    this.typeTimer = setTimeout( () => this.save(), 300 );
                } );
                this.typeRow.append( this.typeInput );
                bar.after( this.typeRow );
            }
        }

        has( feature ) { return this.features.includes( feature ); }

        // Pen Choices: color swatches and line sizes; signature_pad keeps them per stroke
        buildPen() {
            const group = el( "div", "tx-Sig-pen" ),
                start = this.o.penColor || "#1b2a4a",
                colors = [ start ].concat( String( this.o.penColors || "" ).split( "," ).map( c => c.trim() )
                    .filter( c => c && c.toLowerCase() !== start.toLowerCase() ) );
            group.setAttribute( "role", "group" );
            group.setAttribute( "aria-label", "Pen" );
            this.swatches = colors.map( c => {
                const b = el( "button", "tx-Sig-swatch" );
                b.type = "button";
                b.style.setProperty( "--tx-sig-swatch", c );
                b.dataset.color = c;
                b.title = "Pen color " + c;
                b.setAttribute( "aria-label", "Pen color " + c );
                b.addEventListener( "click", () => this.setPen( { color: c } ) );
                return b;
            } );
            this.sizes = Object.keys( WIDTHS ).map( w => {
                const b = el( "button", "tx-Sig-size tx-Sig-size--" + w ),
                    label = w.charAt( 0 ).toUpperCase() + w.slice( 1 ) + " line";
                b.type = "button";
                b.dataset.width = w;
                b.title = label;
                b.setAttribute( "aria-label", label );
                b.append( el( "span", "tx-Sig-sizeDot" ) );
                b.addEventListener( "click", () => this.setPen( { width: w } ) );
                return b;
            } );
            const sep = el( "span", "tx-Sig-sep" );
            sep.setAttribute( "aria-hidden", "true" );
            group.append( ...this.swatches, sep, ...this.sizes );
            return group;
        }

        // the pen for the next strokes (and a typed name): { color, width: fine | medium | bold }
        setPen( pen ) {
            if ( pen.color ) { this.pad.penColor = pen.color; }
            if ( pen.width && WIDTHS[ pen.width ] ) {
                this.penWidth = pen.width;
                this.pad.minWidth = WIDTHS[ pen.width ][ 0 ];
                this.pad.maxWidth = WIDTHS[ pen.width ][ 1 ];
            }
            ( this.swatches || [] ).forEach( b => b.setAttribute( "aria-pressed", String( b.dataset.color.toLowerCase() === this.pad.penColor.toLowerCase() ) ) );
            ( this.sizes || [] ).forEach( b => b.setAttribute( "aria-pressed", String( b.dataset.width === this.penWidth ) ) );
            this.wrap.style.setProperty( "--tx-sig-pen", this.pad.penColor );
            if ( this.typed && pen.color ) {
                this.repaint( [] );
                this.save();
            }
        }

        setTyped( text, keepInput ) {
            this.typed = text;
            if ( this.typeInput && !keepInput ) { this.typeInput.value = text; }
        }

        toggleType( open ) {
            const show = open != null ? open : this.typeRow.hidden;
            this.typeRow.hidden = !show;
            this.typeBtn.setAttribute( "aria-expanded", String( show ) );
            if ( show ) { this.typeInput.focus(); }
        }

        // How strokes map from the reference size (the pad size when they were first drawn) to a w x h pad:
        // scaled to fit and centered, so a signature survives narrowing and widening the page unchanged.
        view( w, h ) {
            const r = this.ref || { w, h }, s = Math.min( w / r.w, h / r.h );
            return { s, dx: ( w - r.w * s ) / 2, dy: ( h - r.h * s ) / 2 };
        }

        // canvas pixels follow the element size and the device pixel ratio; the content is scaled and painted again
        resize() {
            const dpr = Math.max( window.devicePixelRatio || 1, 1 ),
                w = this.area.clientWidth,
                h = this.area.clientHeight;
            if ( !w || !h || ( w === this.cw && h === this.ch && dpr === this.dpr ) ) { return; }
            let data = this.pad.toData().slice();
            if ( !data.length || !this.ref ) {
                this.ref = { w, h };
            } else if ( w !== this.cw || h !== this.ch ) {
                const from = this.view( this.cw, this.ch ), to = this.view( w, h );
                data = data.map( g => Object.assign( {}, g, { points: g.points.map( p => Object.assign( {}, p, {
                    x: ( p.x - from.dx ) / from.s * to.s + to.dx,
                    y: ( p.y - from.dy ) / from.s * to.s + to.dy
                } ) ) } ) );
            }
            this.canvas.width = Math.round( w * dpr );
            this.canvas.height = Math.round( h * dpr );
            this.canvas.style.width = w + "px";
            this.canvas.style.height = h + "px";
            this.canvas.getContext( "2d" ).scale( dpr, dpr );
            this.cw = w;
            this.ch = h;
            this.dpr = dpr;
            this.repaint( data );
        }

        repaint( strokes ) {
            const ctx = this.canvas.getContext( "2d" );
            this.pad.clear();
            if ( this.base && this.base.img.complete && this.base.img.naturalWidth ) {
                const r = this.baseRect();
                ctx.drawImage( this.base.img, r.x, r.y, r.w, r.h );
            }
            if ( this.typed ) { this.drawTyped( ctx ); }
            if ( strokes && strokes.length ) { this.pad.fromData( strokes, { clear: false } ); }
        }

        // a loaded image, scaled down to fit the pad and centered
        baseRect() {
            const img = this.base.img,
                s = Math.min( this.cw / img.naturalWidth, this.ch / img.naturalHeight, 1 ),
                w = img.naturalWidth * s,
                h = img.naturalHeight * s;
            return { x: ( this.cw - w ) / 2, y: ( this.ch - h ) / 2, w, h };
        }

        typedLayout() {
            const ctx = this.canvas.getContext( "2d" );
            let size = Math.min( this.ch * 0.42, 64 );
            ctx.font = size + "px " + SCRIPT_FONT;
            // keeps clear of the line's x on the left
            while ( size > 12 && ctx.measureText( this.typed ).width > this.cw - 112 ) {
                size -= 2;
                ctx.font = size + "px " + SCRIPT_FONT;
            }
            return { size, x: this.cw / 2, y: this.has( "line" ) ? this.ch * LINE_AT - size * 0.18 : this.ch / 2 + size * 0.3 };
        }

        drawTyped( ctx ) {
            const t = this.typedLayout();
            ctx.save();
            ctx.font = t.size + "px " + SCRIPT_FONT;
            ctx.fillStyle = this.pad.penColor;
            ctx.textAlign = "center";
            ctx.textBaseline = "alphabetic";
            ctx.fillText( this.typed, t.x, t.y );
            ctx.restore();
        }

        isEmpty() {
            return !this.base && !this.typed && this.pad.toData().length === 0;
        }

        update() {
            const empty = this.isEmpty();
            this.wrap.classList.toggle( "is-empty", empty );
            if ( this.placeholder ) { this.placeholder.hidden = !empty; }
            [ this.undoBtn, this.clearBtn ].forEach( b => { if ( b ) { b.disabled = empty || this.disabled; } } );
        }

        save() {
            const empty = this.isEmpty();
            this.input.value = empty ? "" : this.exportImage();
            // a "Please sign" error from an earlier submit no longer applies
            if ( !empty ) { apex.message.clearErrors( this.name ); }
            $( this.input ).trigger( "change" );
            this.update();
        }

        exportImage() {
            const fmt = this.o.format;
            if ( fmt === "svg" ) { return this.exportSvg(); }
            const src = this.canvas;
            let r = { x: 0, y: 0, w: src.width, h: src.height };
            if ( this.o.trim ) {
                const b = inkBounds( src ), pad = Math.round( 10 * this.dpr );
                if ( b ) {
                    const x = Math.max( 0, b.x - pad ), y = Math.max( 0, b.y - pad );
                    r = { x, y, w: Math.min( src.width, b.x + b.w + pad ) - x, h: Math.min( src.height, b.y + b.h + pad ) - y };
                }
            }
            const scale = Math.min( 1, ( this.o.maxWidth || 600 ) / r.w ),
                out = document.createElement( "canvas" );
            out.width = Math.max( 1, Math.round( r.w * scale ) );
            out.height = Math.max( 1, Math.round( r.h * scale ) );
            const ctx = out.getContext( "2d" ),
                paper = this.o.background || ( fmt === "jpeg" ? "#ffffff" : null );
            if ( paper ) {
                ctx.fillStyle = paper;
                ctx.fillRect( 0, 0, out.width, out.height );
            }
            ctx.drawImage( src, r.x, r.y, r.w, r.h, 0, 0, out.width, out.height );
            return out.toDataURL( fmt === "jpeg" ? "image/jpeg" : "image/png", 0.92 );
        }

        // signature_pad's SVG of the strokes, with the paper, a loaded image and a typed name added
        exportSvg() {
            const NS = "http://www.w3.org/2000/svg",
                svg = new DOMParser().parseFromString( this.pad.toSVG(), "image/svg+xml" ).documentElement,
                first = svg.firstChild;
            svg.setAttribute( "viewBox", "0 0 " + this.cw + " " + this.ch );
            svg.setAttribute( "width", this.cw );
            svg.setAttribute( "height", this.ch );
            if ( this.o.background ) {
                const rect = document.createElementNS( NS, "rect" );
                rect.setAttribute( "width", "100%" );
                rect.setAttribute( "height", "100%" );
                rect.setAttribute( "fill", this.o.background );
                svg.insertBefore( rect, first );
            }
            if ( this.base && this.base.img.naturalWidth ) {
                const r = this.baseRect(), image = document.createElementNS( NS, "image" );
                image.setAttribute( "x", r.x.toFixed( 2 ) );
                image.setAttribute( "y", r.y.toFixed( 2 ) );
                image.setAttribute( "width", r.w.toFixed( 2 ) );
                image.setAttribute( "height", r.h.toFixed( 2 ) );
                image.setAttribute( "href", this.base.url );
                svg.insertBefore( image, first );
            }
            if ( this.typed ) {
                const t = this.typedLayout(), text = document.createElementNS( NS, "text" );
                text.setAttribute( "x", t.x.toFixed( 2 ) );
                text.setAttribute( "y", t.y.toFixed( 2 ) );
                text.setAttribute( "font-size", t.size );
                text.setAttribute( "font-family", SCRIPT_FONT.replace( /"/g, "'" ) );
                text.setAttribute( "text-anchor", "middle" );
                text.setAttribute( "fill", this.pad.penColor );
                text.textContent = this.typed;
                svg.append( text );
            }
            const xml = new XMLSerializer().serializeToString( svg ),
                bytes = new TextEncoder().encode( xml );
            let bin = "";
            bytes.forEach( b => { bin += String.fromCharCode( b ); } );
            return "data:image/svg+xml;base64," + btoa( bin );
        }

        load( url ) {
            this.setTyped( "" );
            this.base = null;
            if ( url && DATA_URL.test( url ) ) {
                const img = new Image();
                this.base = { url, img };
                img.onload = () => { if ( this.base && this.base.img === img ) { this.repaint( [] ); this.update(); } };
                img.src = url;
            }
            this.repaint( [] );
            this.update();
        }

        undo() {
            const strokes = this.pad.toData().slice();
            if ( strokes.length ) {
                strokes.pop();
            } else if ( this.typed ) {
                this.setTyped( "" );
            } else {
                this.base = null;
            }
            this.repaint( strokes );
            this.save();
        }

        clear( byUser ) {
            this.base = null;
            this.setTyped( "" );
            this.repaint( [] );
            this.save();
            if ( byUser ) {
                apex.event.trigger( this.input, "tx-signaturepad-clear" );
                ( this.typeBtn || this.canvas ).focus();
            }
        }

        setDisabled( disabled ) {
            this.disabled = disabled;
            this.input.disabled = disabled;
            this.wrap.classList.toggle( "is-disabled", disabled );
            if ( disabled ) { this.pad.off(); } else { this.pad.on(); }
            if ( this.typeBtn ) { this.typeBtn.disabled = disabled; }
            ( this.swatches || [] ).concat( this.sizes || [] ).forEach( b => { b.disabled = disabled; } );
            if ( this.typeInput ) { this.typeInput.disabled = disabled; }
            this.update();
        }
    }

    const pads = {};
    ns.signaturePad = {
        init( itemName, options, initFn ) {
            if ( typeof initFn === "function" ) { options = initFn( options ) || options; }
            const p = new Pad( itemName, options );
            pads[ itemName ] = p;
            apex.item.create( itemName, {
                getValue: () => p.input.value,
                setValue: value => {
                    p.input.value = value && DATA_URL.test( value ) ? value : "";
                    p.load( p.input.value );
                },
                isEmpty: () => p.isEmpty(),
                isChanged: () => p.input.value !== p.input.defaultValue,
                enable: () => p.setDisabled( false ),
                disable: () => p.setDisabled( true ),
                isDisabled: () => p.disabled,
                setFocusTo: () => $( p.typeBtn || p.undoBtn || p.canvas ),
                getValidity: () => {
                    const missing = !!p.o.required && p.isEmpty();
                    return { valid: !missing, valueMissing: missing };
                },
                getValidationMessage: () => ( p.o.required && p.isEmpty() ? "Please sign." : "" )
            } );
        },
        get: itemName => pads[ itemName ]
    };
} )( apex.jQuery, apex );
