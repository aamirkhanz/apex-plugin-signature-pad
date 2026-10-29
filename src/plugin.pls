-- Signature Pad item plug-in (TechRevX, www.techrevx.com)
-- The value is an image data URL (data:image/png|jpeg|svg+xml;base64,...). Other values are not shown.
-- render: read only -> the image; otherwise a hidden input with the value, and techrevx.signaturePad.init
--         (signature-pad.js) builds the pad around it.

function item_value( p_item in apex_plugin.t_item, p_param in apex_plugin.t_item_render_param ) return clob is
    l_value clob;
begin
    -- CLOB session state holds values above 32 KB; p_param.value is limited to VARCHAR2
    begin
        l_value := apex_session_state.get_clob( p_item.name );
    exception
        when others then
            l_value := null;
    end;
    if l_value is null or dbms_lob.getlength( l_value ) = 0 then
        l_value := p_param.value;
    end if;
    if l_value is not null
       and not regexp_like( l_value, '^data:image/(png|jpeg|svg\+xml);base64,[A-Za-z0-9+/=]+$' ) then
        l_value := null;
    end if;
    return l_value;
end item_value;

procedure render (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result )
is
    l_id    varchar2( 255 ) := apex_escape.html_attribute( p_item.name );
    l_value clob := item_value( p_item, p_param );
begin
    if p_param.is_readonly or p_param.is_printer_friendly then
        sys.htp.prn( '<div class="tx-Sig tx-Sig--readonly" id="' || l_id || '_sig"'
                     || case when p_item.element_attributes is not null then ' ' || p_item.element_attributes end || '>' );
        if l_value is not null then
            sys.htp.prn( '<img class="tx-Sig-image" alt="Signature" src="' );
            apex_util.prn( p_clob => l_value, p_escape => false );
            sys.htp.prn( '">' );
        else
            sys.htp.prn( '<span class="tx-Sig-none">No signature</span>' );
        end if;
        sys.htp.p( '</div>' );
        apex_plugin_util.print_hidden_if_readonly( p_item => p_item, p_param => p_param );
        return;
    end if;

    sys.htp.prn( '<div class="tx-Sig" id="' || l_id || '_sig"'
                 || case when p_item.element_attributes is not null then ' ' || p_item.element_attributes end || '>' );
    sys.htp.prn( '<input type="hidden" id="' || l_id || '" name="' || apex_plugin.get_input_name_for_item || '" value="' );
    if l_value is not null then
        apex_util.prn( p_clob => l_value, p_escape => false );
    end if;
    sys.htp.p( '"></div>' );

    apex_javascript.add_onload_code( p_code =>
        'techrevx.signaturePad.init(' || apex_javascript.add_value( p_item.name ) || '{'
        || apex_javascript.add_attribute( 'height', nvl( p_item.attributes.get_number( 'HEIGHT' ), 200 ) )
        || apex_javascript.add_attribute( 'sizing', nvl( p_item.attributes.get_varchar2( 'SIZING' ), 'responsive' ) )
        || apex_javascript.add_attribute( 'penColor', p_item.attributes.get_varchar2( 'PEN_COLOR' ) )
        || apex_javascript.add_attribute( 'penColors', p_item.attributes.get_varchar2( 'PEN_COLORS' ) )
        || apex_javascript.add_attribute( 'penWidth', p_item.attributes.get_varchar2( 'PEN_WIDTH' ) )
        || apex_javascript.add_attribute( 'background', p_item.attributes.get_varchar2( 'BACKGROUND' ) )
        || apex_javascript.add_attribute( 'placeholder', p_item.attributes.get_varchar2( 'PLACEHOLDER' ) )
        || apex_javascript.add_attribute( 'features', p_item.attributes.get_varchar2( 'FEATURES' ) )
        || apex_javascript.add_attribute( 'format', p_item.attributes.get_varchar2( 'FORMAT' ) )
        || apex_javascript.add_attribute( 'trim', instr( ':' || p_item.attributes.get_varchar2( 'OUTPUT_OPTIONS' ) || ':', ':trim:' ) > 0 )
        || apex_javascript.add_attribute( 'maxWidth', nvl( p_item.attributes.get_number( 'MAX_WIDTH' ), 600 ) )
        || apex_javascript.add_attribute( 'required', p_item.is_required, false, false )
        || '}, ' || nvl( p_item.init_javascript_code, 'null' ) || ');' );

    p_result.is_navigable := true;
end render;
