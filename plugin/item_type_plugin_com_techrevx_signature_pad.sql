prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.04.07'
,p_release=>'26.2.0'
,p_default_workspace_id=>6202419497391597
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'AAMIRKHANZ'
);
end;
/
 
prompt APPLICATION 100 - Apex Plug-ins
--
-- Application Export:
--   Application:     100
--   Name:            Apex Plug-ins
--   Date and Time:   09:17 Thursday October 29, 2026
--   Exported By:     AAMIRKHANZ
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 6145944884671963
--   Manifest End
--   Version:         26.2.0
--   Instance ID:     2400160207269871
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/com_techrevx_signature_pad
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(6145944884671963)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.TECHREVX.SIGNATURE_PAD'
,p_display_name=>'Signature Pad'
,p_apexlang_name=>'signaturePad'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#signature_pad.umd.min.js',
'#PLUGIN_FILES#signature-pad.js'))
,p_css_file_urls=>'#PLUGIN_FILES#signature-pad.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Signature Pad item plug-in (TechRevX, www.techrevx.com)',
'-- The value is an image data URL (data:image/png|jpeg|svg+xml;base64,...). Other values are not shown.',
'-- render: read only -> the image; otherwise a hidden input with the value, and techrevx.signaturePad.init',
'--         (signature-pad.js) builds the pad around it.',
'',
'function item_value( p_item in apex_plugin.t_item, p_param in apex_plugin.t_item_render_param ) return clob is',
'    l_value clob;',
'begin',
'    -- CLOB session state holds values above 32 KB; p_param.value is limited to VARCHAR2',
'    begin',
'        l_value := apex_session_state.get_clob( p_item.name );',
'    exception',
'        when others then',
'            l_value := null;',
'    end;',
'    if l_value is null or dbms_lob.getlength( l_value ) = 0 then',
'        l_value := p_param.value;',
'    end if;',
'    if l_value is not null',
'       and not regexp_like( l_value, ''^data:image/(png|jpeg|svg\+xml);base64,[A-Za-z0-9+/=]+$'' ) then',
'        l_value := null;',
'    end if;',
'    return l_value;',
'end item_value;',
'',
'procedure render (',
'    p_item   in            apex_plugin.t_item,',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_param  in            apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result )',
'is',
'    l_id    varchar2( 255 ) := apex_escape.html_attribute( p_item.name );',
'    l_value clob := item_value( p_item, p_param );',
'begin',
'    if p_param.is_readonly or p_param.is_printer_friendly then',
'        sys.htp.prn( ''<div class="tx-Sig tx-Sig--readonly" id="'' || l_id || ''_sig"''',
'                     || case when p_item.element_attributes is not null then '' '' || p_item.element_attributes end || ''>'' );',
'        if l_value is not null then',
'            sys.htp.prn( ''<img class="tx-Sig-image" alt="Signature" src="'' );',
'            apex_util.prn( p_clob => l_value, p_escape => false );',
'            sys.htp.prn( ''">'' );',
'        else',
'            sys.htp.prn( ''<span class="tx-Sig-none">No signature</span>'' );',
'        end if;',
'        sys.htp.p( ''</div>'' );',
'        apex_plugin_util.print_hidden_if_readonly( p_item => p_item, p_param => p_param );',
'        return;',
'    end if;',
'',
'    sys.htp.prn( ''<div class="tx-Sig" id="'' || l_id || ''_sig"''',
'                 || case when p_item.element_attributes is not null then '' '' || p_item.element_attributes end || ''>'' );',
'    sys.htp.prn( ''<input type="hidden" id="'' || l_id || ''" name="'' || apex_plugin.get_input_name_for_item || ''" value="'' );',
'    if l_value is not null then',
'        apex_util.prn( p_clob => l_value, p_escape => false );',
'    end if;',
'    sys.htp.p( ''"></div>'' );',
'',
'    apex_javascript.add_onload_code( p_code =>',
'        ''techrevx.signaturePad.init('' || apex_javascript.add_value( p_item.name ) || ''{''',
'        || apex_javascript.add_attribute( ''height'', nvl( p_item.attributes.get_number( ''HEIGHT'' ), 200 ) )',
'        || apex_javascript.add_attribute( ''sizing'', nvl( p_item.attributes.get_varchar2( ''SIZING'' ), ''responsive'' ) )',
'        || apex_javascript.add_attribute( ''penColor'', p_item.attributes.get_varchar2( ''PEN_COLOR'' ) )',
'        || apex_javascript.add_attribute( ''penColors'', p_item.attributes.get_varchar2( ''PEN_COLORS'' ) )',
'        || apex_javascript.add_attribute( ''penWidth'', p_item.attributes.get_varchar2( ''PEN_WIDTH'' ) )',
'        || apex_javascript.add_attribute( ''background'', p_item.attributes.get_varchar2( ''BACKGROUND'' ) )',
'        || apex_javascript.add_attribute( ''placeholder'', p_item.attributes.get_varchar2( ''PLACEHOLDER'' ) )',
'        || apex_javascript.add_attribute( ''features'', p_item.attributes.get_varchar2( ''FEATURES'' ) )',
'        || apex_javascript.add_attribute( ''format'', p_item.attributes.get_varchar2( ''FORMAT'' ) )',
'        || apex_javascript.add_attribute( ''trim'', instr( '':'' || p_item.attributes.get_varchar2( ''OUTPUT_OPTIONS'' ) || '':'', '':trim:'' ) > 0 )',
'        || apex_javascript.add_attribute( ''maxWidth'', nvl( p_item.attributes.get_number( ''MAX_WIDTH'' ), 600 ) )',
'        || apex_javascript.add_attribute( ''required'', p_item.is_required, false, false )',
'        || ''}, '' || nvl( p_item.init_javascript_code, ''null'' ) || '');'' );',
'',
'    p_result.is_navigable := true;',
'end render;'))
,p_api_version=>3
,p_render_function=>'render'
,p_item_session_state_data_type=>'VARCHAR2'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE:ELEMENT:INIT_JAVASCRIPT_CODE'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Signature Pad: A page item where users sign with a mouse, finger or pen, or type their name, and the signature is saved as an image.',
'',
'Value: an image data URL (PNG, JPEG or SVG). Set Session State Data Type to CLOB. Save it to a BLOB with apex_web_service.clobbase642blob( substr( :P1_SIGNATURE, instr( :P1_SIGNATURE, '','' ) + 1 ) ).',
'Drawing: smooth, pressure-like lines (the faster the pen, the thinner the line), undo, clear, a signature line and a placeholder. With Pen Choices, users pick the line color and size (Fine, Medium, Bold). The pad is responsive: on narrow screens it k'
||'eeps a 2:1 shape up to the Height, and the signature scales to fit when the pad changes size.',
'Type Instead: users type their name and it is drawn in a handwriting font, so the item also works with a keyboard.',
'Output: PNG, JPEG or SVG, cropped to the signature and scaled to a maximum width. Read only items show the image.',
'Validation: Value Required works on the server and in the browser. JavaScript: apex.item( "P1_SIGNATURE" ).getValue(), setValue( dataUrl ), isEmpty(). Events: Change, Signature Pad - Signing Started, Signature Pad - Cleared.',
'',
'Signature Pad (szimek/signature_pad) is licensed under the MIT License.',
'Documentation, updates and more plugins: https://www.techrevx.com'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://www.techrevx.com'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Drawing library: signature_pad 5.1.4, included',
'Value: PNG, JPEG or SVG data URL',
'License: signature_pad MIT License'))
,p_files_version=>2461343091607
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(6146068355671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_title=>'Output'
,p_apexlang_name=>'output'
,p_static_id=>'OUTPUT'
,p_display_sequence=>20
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(6146126770671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_title=>'Pad'
,p_apexlang_name=>'pad'
,p_static_id=>'PAD'
,p_display_sequence=>10
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6146298621671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'BACKGROUND'
,p_prompt=>'Background Color'
,p_apexlang_name=>'background'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Paper color of the pad, also used behind the saved image. Leave empty for a transparent PNG or SVG; JPEG images get white.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6146325679671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_static_id=>'FEATURES'
,p_prompt=>'Features'
,p_apexlang_name=>'features'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'undo:clear:type:line:pen'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Undo: removes the last stroke. Clear: empties the pad. Type: lets users type their name instead of drawing it, which also makes the item usable with a keyboard. Signature Line: a baseline with an x to sign on. Pen Choices: color swatches (from Pen Co'
||'lors) and Fine, Medium and Bold line sizes; each stroke keeps the color and size it was drawn with.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6146558422671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146325679671963)
,p_display_sequence=>20
,p_display_value=>'Clear'
,p_return_value=>'clear'
,p_apexlang_name=>'clear'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6146778239671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146325679671963)
,p_display_sequence=>40
,p_display_value=>'Signature Line'
,p_return_value=>'line'
,p_apexlang_name=>'line'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6162545845714061)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146325679671963)
,p_display_sequence=>50
,p_display_value=>'Pen Choices'
,p_return_value=>'pen'
,p_apexlang_name=>'pen'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6146638337671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146325679671963)
,p_display_sequence=>30
,p_display_value=>'Type Instead'
,p_return_value=>'type'
,p_apexlang_name=>'type'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6146462254671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146325679671963)
,p_display_sequence=>10
,p_display_value=>'Undo'
,p_return_value=>'undo'
,p_apexlang_name=>'undo'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6146871935671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>10
,p_static_id=>'FORMAT'
,p_prompt=>'Image Format'
,p_apexlang_name=>'format'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'png'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(6146068355671963)
,p_help_text=>'The item value is a data URL of this image type, for example data:image/png;base64,iVBOR... PNG keeps a transparent background; JPEG is smaller; SVG stays sharp at any size.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6147092155671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146871935671963)
,p_display_sequence=>20
,p_display_value=>'JPEG'
,p_return_value=>'jpeg'
,p_apexlang_name=>'jpeg'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6146929159671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146871935671963)
,p_display_sequence=>10
,p_display_value=>'PNG'
,p_return_value=>'png'
,p_apexlang_name=>'png'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6147146171671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6146871935671963)
,p_display_sequence=>30
,p_display_value=>'SVG'
,p_return_value=>'svg'
,p_apexlang_name=>'svg'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6147269007671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'HEIGHT'
,p_prompt=>'Height'
,p_apexlang_name=>'height'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'200'
,p_unit=>'px'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Height of the drawing area; with Responsive sizing it is the maximum height. The pad is always as wide as the item.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6147335226671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>30
,p_static_id=>'MAX_WIDTH'
,p_prompt=>'Maximum Image Width'
,p_apexlang_name=>'maxWidth'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'600'
,p_unit=>'px'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(6146068355671963)
,p_help_text=>'PNG and JPEG images wider than this are scaled down, which keeps the value small. Set the item''s Session State Data Type to CLOB for values above 32 KB.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6147452853671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>20
,p_static_id=>'OUTPUT_OPTIONS'
,p_prompt=>'Crop to Signature'
,p_apexlang_name=>'outputOptions'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'trim'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(6146068355671963)
,p_help_text=>'Removes the empty space around the signature in PNG and JPEG images, so they are small and line up when shown.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6147544639671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6147452853671963)
,p_display_sequence=>10
,p_display_value=>'Crop to Signature'
,p_return_value=>'trim'
,p_apexlang_name=>'trim'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6147629129671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'PEN_COLOR'
,p_prompt=>'Pen Color'
,p_apexlang_name=>'penColor'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#1b2a4a'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Color the pad starts with. With Pen Choices, users can pick another one from Pen Colors.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6162698028714061)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>25
,p_static_id=>'PEN_COLORS'
,p_prompt=>'Pen Colors'
,p_apexlang_name=>'penColors'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'#1b2a4a,#1d3fa0,#0f7b4f,#b3261e'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_examples=>'#1b2a4a,#1d3fa0,#0f7b4f,#b3261e'
,p_help_text=>'Colors users can choose from when Pen Choices is on, as CSS colors separated by commas. The Pen Color is always offered first.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6147723676671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'PEN_WIDTH'
,p_prompt=>'Pen Width'
,p_apexlang_name=>'penWidth'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'medium'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Line size the pad starts with; with Pen Choices, users can switch between Fine, Medium and Bold. The line gets thinner when the pen moves faster, like ink.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6148062754671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6147723676671963)
,p_display_sequence=>30
,p_display_value=>'Bold'
,p_return_value=>'bold'
,p_apexlang_name=>'bold'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6147822964671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6147723676671963)
,p_display_sequence=>10
,p_display_value=>'Fine'
,p_return_value=>'fine'
,p_apexlang_name=>'fine'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6147965964671963)
,p_plugin_attribute_id=>wwv_flow_imp.id(6147723676671963)
,p_display_sequence=>20
,p_display_value=>'Medium'
,p_return_value=>'medium'
,p_apexlang_name=>'medium'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6148125001671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_static_id=>'PLACEHOLDER'
,p_prompt=>'Placeholder'
,p_apexlang_name=>'placeholder'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Sign here'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Text shown on the empty pad.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6174547455743793)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>15
,p_static_id=>'SIZING'
,p_prompt=>'Sizing'
,p_apexlang_name=>'sizing'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'responsive'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(6146126770671963)
,p_help_text=>'Responsive: the pad keeps a 2:1 shape on narrow screens, up to the Height, and at least 120 px tall. Fixed: always the Height. Either way the signature is scaled to fit when the pad changes size.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6174736923743793)
,p_plugin_attribute_id=>wwv_flow_imp.id(6174547455743793)
,p_display_sequence=>20
,p_display_value=>'Fixed Height'
,p_return_value=>'fixed'
,p_apexlang_name=>'fixed'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(6174665554743793)
,p_plugin_attribute_id=>wwv_flow_imp.id(6174547455743793)
,p_display_sequence=>10
,p_display_value=>'Responsive'
,p_return_value=>'responsive'
,p_apexlang_name=>'responsive'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(6148237602671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_name=>'tx-signaturepad-begin'
,p_display_name=>'Signature Pad - Signing Started'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(6148393118671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_name=>'tx-signaturepad-clear'
,p_display_name=>'Signature Pad - Cleared'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A205369676E617475726520506164206974656D20706C75672D696E202854656368526576582C207777772E74656368726576782E636F6D29202A2F0A2E74782D536967207B0A20202D2D74782D7369672D6C696E653A20766172282D2D612D666965';
wwv_flow_imp.g_varchar2_table(2) := '6C642D696E7075742D626F726465722D636F6C6F722C20766172282D2D75742D6669656C642D626F726465722D636F6C6F722C207267626128302C20302C20302C202E31382929293B0A20202D2D74782D7369672D746578743A20766172282D2D75742D';
wwv_flow_imp.g_varchar2_table(3) := '636F6D706F6E656E742D746578742D64656661756C742D636F6C6F722C2023316632333333293B0A20202D2D74782D7369672D6D757465643A20766172282D2D75742D636F6D706F6E656E742D746578742D6D757465642D636F6C6F722C202336623730';
wwv_flow_imp.g_varchar2_table(4) := '3830293B0A20202D2D74782D7369672D616363656E743A20766172282D2D75742D70616C657474652D7072696D6172792C2023333434326138293B0A202077696474683A20313030253B0A20206D696E2D77696474683A20303B0A7D0A0A2E74782D5369';
wwv_flow_imp.g_varchar2_table(5) := '672D61726561207B0A20202D2D74782D7369672D70617065723A20766172282D2D612D6669656C642D696E7075742D6261636B67726F756E642D636F6C6F722C20766172282D2D75742D6669656C642D6261636B67726F756E642D636F6C6F722C202366';
wwv_flow_imp.g_varchar2_table(6) := '666629293B0A2020706F736974696F6E3A2072656C61746976653B0A20206F766572666C6F773A2068696464656E3B0A2020626F726465723A2031707820736F6C696420766172282D2D74782D7369672D6C696E65293B0A2020626F726465722D726164';
wwv_flow_imp.g_varchar2_table(7) := '6975733A20766172282D2D612D6669656C642D696E7075742D626F726465722D7261646975732C20367078293B0A20206261636B67726F756E643A20766172282D2D74782D7369672D7061706572293B0A2020637572736F723A2063726F737368616972';
wwv_flow_imp.g_varchar2_table(8) := '3B0A20207472616E736974696F6E3A20626F726465722D636F6C6F72202E3135732C20626F782D736861646F77202E3135733B0A7D0A2F2A20526573706F6E736976652073697A696E673A2066756C6C2077696474682C20323A31206F6E206E6172726F';
wwv_flow_imp.g_varchar2_table(9) := '772073637265656E732C204865696768742028696E6C696E65206D61782D68656967687429206F6E2077696465206F6E6573202A2F0A2F2A20616E206578706C696369742077696474683A2077697468207769647468206175746F2C206D61782D686569';
wwv_flow_imp.g_varchar2_table(10) := '67687420776F756C6420616C736F2063617020746865207769647468207468726F756768207468652061737065637420726174696F202A2F0A2E74782D5369672D617265612D2D726573706F6E73697665207B2077696474683A20313030253B20617370';
wwv_flow_imp.g_varchar2_table(11) := '6563742D726174696F3A2032202F20313B206D696E2D6865696768743A2031323070783B207D0A2E74782D5369672E69732D64726177696E67202E74782D5369672D617265612C0A2E74782D5369672D617265613A666F6375732D77697468696E207B20';
wwv_flow_imp.g_varchar2_table(12) := '626F726465722D636F6C6F723A20766172282D2D74782D7369672D616363656E74293B20626F782D736861646F773A2030203020302031707820766172282D2D74782D7369672D616363656E74293B207D0A2E74782D5369672D63616E766173207B2070';
wwv_flow_imp.g_varchar2_table(13) := '6F736974696F6E3A206162736F6C7574653B20696E7365743A20303B20646973706C61793A20626C6F636B3B206F75746C696E653A206E6F6E653B207D0A0A2F2A20626173656C696E65207769746820616E20782C206C696B6520612070617065722066';
wwv_flow_imp.g_varchar2_table(14) := '6F726D3B20373225206D617463686573204C494E455F415420696E207369676E61747572652D7061642E6A73202A2F0A2E74782D5369672D6C696E65207B0A2020706F736974696F6E3A206162736F6C7574653B0A20206C6566743A20323870783B0A20';
wwv_flow_imp.g_varchar2_table(15) := '2072696768743A20323870783B0A2020746F703A203732253B0A2020626F726465722D746F703A20312E35707820736F6C696420636F6C6F722D6D697828696E20737267622C20766172282D2D74782D7369672D7465787429203330252C207472616E73';
wwv_flow_imp.g_varchar2_table(16) := '706172656E74293B0A2020706F696E7465722D6576656E74733A206E6F6E653B0A7D0A2E74782D5369672D6C696E653A3A6265666F7265207B0A2020636F6E74656E743A20225C30306437223B0A2020706F736974696F6E3A206162736F6C7574653B0A';
wwv_flow_imp.g_varchar2_table(17) := '20206C6566743A203270783B0A2020626F74746F6D3A203470783B0A2020636F6C6F723A20636F6C6F722D6D697828696E20737267622C20766172282D2D74782D7369672D7465787429203435252C207472616E73706172656E74293B0A2020666F6E74';
wwv_flow_imp.g_varchar2_table(18) := '2D73697A653A20323070783B0A20206C696E652D6865696768743A20313B0A7D0A2E74782D5369672D706C616365686F6C646572207B0A2020706F736974696F6E3A206162736F6C7574653B0A20206C6566743A20303B0A202072696768743A20303B0A';
wwv_flow_imp.g_varchar2_table(19) := '2020746F703A203530253B0A20207472616E73666F726D3A207472616E736C61746559282D353025293B0A2020636F6C6F723A20766172282D2D74782D7369672D6D75746564293B0A2020666F6E742D73697A653A20313370783B0A2020746578742D61';
wwv_flow_imp.g_varchar2_table(20) := '6C69676E3A2063656E7465723B0A2020706F696E7465722D6576656E74733A206E6F6E653B0A7D0A2E74782D5369672D617265612E6861732D6C696E65202E74782D5369672D706C616365686F6C646572207B20746F703A2063616C6328373225202B20';
wwv_flow_imp.g_varchar2_table(21) := '387078293B207472616E73666F726D3A206E6F6E653B207D0A2E74782D5369672D706C616365686F6C6465725B68696464656E5D207B20646973706C61793A206E6F6E653B207D0A0A2E74782D5369672D626172207B20646973706C61793A20666C6578';
wwv_flow_imp.g_varchar2_table(22) := '3B20666C65782D777261703A20777261703B20616C69676E2D6974656D733A2063656E7465723B206761703A203270783B206D617267696E2D746F703A203470783B207D0A2E74782D5369672D62746E207B0A2020646973706C61793A20696E6C696E65';
wwv_flow_imp.g_varchar2_table(23) := '2D666C65783B0A2020616C69676E2D6974656D733A2063656E7465723B0A20206761703A203670783B0A20206D696E2D6865696768743A20333070783B0A202070616464696E673A203020313070783B0A2020626F726465723A20303B0A2020626F7264';
wwv_flow_imp.g_varchar2_table(24) := '65722D7261646975733A203670783B0A20206261636B67726F756E643A207472616E73706172656E743B0A2020636F6C6F723A20766172282D2D74782D7369672D6D75746564293B0A2020666F6E743A20696E68657269743B0A2020666F6E742D73697A';
wwv_flow_imp.g_varchar2_table(25) := '653A20313370783B0A2020637572736F723A20706F696E7465723B0A7D0A2E74782D5369672D62746E3A686F7665723A6E6F74283A64697361626C656429207B206261636B67726F756E643A20636F6C6F722D6D697828696E20737267622C2076617228';
wwv_flow_imp.g_varchar2_table(26) := '2D2D74782D7369672D74657874292038252C207472616E73706172656E74293B20636F6C6F723A20766172282D2D74782D7369672D74657874293B207D0A2E74782D5369672D62746E3A666F6375732D76697369626C65207B206F75746C696E653A2032';
wwv_flow_imp.g_varchar2_table(27) := '707820736F6C696420766172282D2D74782D7369672D616363656E74293B206F75746C696E652D6F66667365743A203170783B207D0A2E74782D5369672D62746E3A64697361626C6564207B206F7061636974793A202E34353B20637572736F723A2064';
wwv_flow_imp.g_varchar2_table(28) := '656661756C743B207D0A2E74782D536967202E74782D5369672D62746E202E6661207B20666F6E742D73697A653A20313370783B2077696474683A206175746F3B207D0A2E74782D5369672D7479706542746E5B617269612D657870616E6465643D2274';
wwv_flow_imp.g_varchar2_table(29) := '727565225D207B20636F6C6F723A20766172282D2D74782D7369672D616363656E74293B207D0A2E74782D5369672D616374696F6E73207B20646973706C61793A20666C65783B206761703A203270783B206D617267696E2D6C6566743A206175746F3B';
wwv_flow_imp.g_varchar2_table(30) := '207D0A0A2F2A2050656E2043686F696365733A20636F6C6F722073776174636865732C207468656E206C696E652073697A657320647261776E20617320646F747320696E207468652063757272656E742070656E20636F6C6F72202A2F0A2E74782D5369';
wwv_flow_imp.g_varchar2_table(31) := '672D70656E207B20646973706C61793A20666C65783B20616C69676E2D6974656D733A2063656E7465723B206761703A203270783B2070616464696E673A2030203470783B207D0A2E74782D5369672D7377617463682C0A2E74782D5369672D73697A65';
wwv_flow_imp.g_varchar2_table(32) := '207B0A2020646973706C61793A20677269643B0A2020706C6163652D6974656D733A2063656E7465723B0A202077696474683A20333070783B0A20206865696768743A20333070783B0A202070616464696E673A20303B0A2020626F726465723A20303B';
wwv_flow_imp.g_varchar2_table(33) := '0A2020626F726465722D7261646975733A203530253B0A20206261636B67726F756E643A207472616E73706172656E743B0A2020637572736F723A20706F696E7465723B0A7D0A2E74782D5369672D7377617463683A3A6265666F7265207B0A2020636F';
wwv_flow_imp.g_varchar2_table(34) := '6E74656E743A2022223B0A202077696474683A20313870783B0A20206865696768743A20313870783B0A2020626F726465722D7261646975733A203530253B0A20206261636B67726F756E643A20766172282D2D74782D7369672D737761746368293B0A';
wwv_flow_imp.g_varchar2_table(35) := '2020626F782D736861646F773A20696E73657420302030203020317078207267626128302C20302C20302C202E3132293B0A7D0A2E74782D5369672D7377617463685B617269612D707265737365643D2274727565225D3A3A6265666F7265207B20626F';
wwv_flow_imp.g_varchar2_table(36) := '782D736861646F773A2030203020302032707820766172282D2D612D6669656C642D696E7075742D6261636B67726F756E642D636F6C6F722C2023666666292C2030203020302034707820766172282D2D74782D7369672D737761746368293B207D0A2E';
wwv_flow_imp.g_varchar2_table(37) := '74782D5369672D73697A653A686F7665723A6E6F74283A64697361626C6564292C0A2E74782D5369672D7377617463683A686F7665723A6E6F74283A64697361626C656429207B206261636B67726F756E643A20636F6C6F722D6D697828696E20737267';
wwv_flow_imp.g_varchar2_table(38) := '622C20766172282D2D74782D7369672D74657874292038252C207472616E73706172656E74293B207D0A2E74782D5369672D73697A655B617269612D707265737365643D2274727565225D207B206261636B67726F756E643A20636F6C6F722D6D697828';
wwv_flow_imp.g_varchar2_table(39) := '696E20737267622C20766172282D2D74782D7369672D7465787429203131252C207472616E73706172656E74293B207D0A2E74782D5369672D73697A65446F74207B20626F726465722D7261646975733A203530253B206261636B67726F756E643A2076';
wwv_flow_imp.g_varchar2_table(40) := '6172282D2D74782D7369672D70656E2C20766172282D2D74782D7369672D7465787429293B207D0A2E74782D5369672D73697A652D2D66696E65202E74782D5369672D73697A65446F74207B2077696474683A203470783B206865696768743A20347078';
wwv_flow_imp.g_varchar2_table(41) := '3B207D0A2E74782D5369672D73697A652D2D6D656469756D202E74782D5369672D73697A65446F74207B2077696474683A203770783B206865696768743A203770783B207D0A2E74782D5369672D73697A652D2D626F6C64202E74782D5369672D73697A';
wwv_flow_imp.g_varchar2_table(42) := '65446F74207B2077696474683A20313170783B206865696768743A20313170783B207D0A2E74782D5369672D7377617463683A666F6375732D76697369626C652C0A2E74782D5369672D73697A653A666F6375732D76697369626C65207B206F75746C69';
wwv_flow_imp.g_varchar2_table(43) := '6E653A2032707820736F6C696420766172282D2D74782D7369672D616363656E74293B206F75746C696E652D6F66667365743A203170783B207D0A2E74782D5369672D7377617463683A64697361626C65642C0A2E74782D5369672D73697A653A646973';
wwv_flow_imp.g_varchar2_table(44) := '61626C6564207B206F7061636974793A202E34353B20637572736F723A2064656661756C743B207D0A2E74782D5369672D736570207B2077696474683A203170783B206865696768743A20313870783B206D617267696E3A2030203470783B206261636B';
wwv_flow_imp.g_varchar2_table(45) := '67726F756E643A20766172282D2D74782D7369672D6C696E65293B207D0A0A2E74782D5369672D74797065526F77207B206D617267696E2D746F703A203470783B207D0A2E74782D5369672D74797065526F775B68696464656E5D207B20646973706C61';
wwv_flow_imp.g_varchar2_table(46) := '793A206E6F6E653B207D0A2E74782D5369672D74797065496E707574207B0A202077696474683A20313030253B0A20206865696768743A20333670783B0A202070616464696E673A203020313070783B0A2020626F726465723A2031707820736F6C6964';
wwv_flow_imp.g_varchar2_table(47) := '20766172282D2D74782D7369672D6C696E65293B0A2020626F726465722D7261646975733A20766172282D2D612D6669656C642D696E7075742D626F726465722D7261646975732C20367078293B0A20206261636B67726F756E643A20766172282D2D61';
wwv_flow_imp.g_varchar2_table(48) := '2D6669656C642D696E7075742D6261636B67726F756E642D636F6C6F722C2023666666293B0A2020636F6C6F723A20766172282D2D74782D7369672D74657874293B0A2020666F6E743A20696E68657269743B0A7D0A2E74782D5369672D74797065496E';
wwv_flow_imp.g_varchar2_table(49) := '7075743A666F637573207B206F75746C696E653A2032707820736F6C696420766172282D2D74782D7369672D616363656E74293B206F75746C696E652D6F66667365743A202D3170783B20626F726465722D636F6C6F723A207472616E73706172656E74';
wwv_flow_imp.g_varchar2_table(50) := '3B20626F782D736861646F773A206E6F6E653B207D0A0A2E74782D5369672E69732D64697361626C6564202E74782D5369672D61726561207B206F7061636974793A202E363B20637572736F723A206E6F742D616C6C6F7765643B207D0A0A2E74782D53';
wwv_flow_imp.g_varchar2_table(51) := '69672D2D726561646F6E6C79207B206D696E2D6865696768743A20323470783B207D0A2E74782D5369672D696D616765207B20646973706C61793A20626C6F636B3B206D61782D77696474683A20313030253B206865696768743A206175746F3B206D61';
wwv_flow_imp.g_varchar2_table(52) := '782D6865696768743A2031363070783B207D0A2E74782D5369672D6E6F6E65207B20636F6C6F723A20766172282D2D74782D7369672D6D75746564293B207D0A0A406D656469612028707265666572732D726564756365642D6D6F74696F6E3A20726564';
wwv_flow_imp.g_varchar2_table(53) := '75636529207B0A20202E74782D5369672D61726561207B207472616E736974696F6E3A206E6F6E653B207D0A7D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(6148457394671963)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_file_name=>'signature-pad.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A0A202A205369676E617475726520506164206974656D20706C75672D696E20666F72204F7261636C652041504558202854656368526576582C207777772E74656368726576782E636F6D290A202A0A202A2074656368726576782E7369676E617475';
wwv_flow_imp.g_varchar2_table(2) := '72655061642E696E697428206974656D4E616D652C206F7074696F6E732C20696E6974466E20292069732063616C6C6564206279207468652072656E6465722070726F6365647572652E20546865206974656D27732076616C7565206C6976657320696E';
wwv_flow_imp.g_varchar2_table(3) := '0A202A207468652068696464656E20696E70757420233C6974656D4E616D653E3B2074686520706164206973206275696C7420696E20233C6974656D4E616D653E5F7369672061726F756E642069742E2044726177696E672075736573207369676E6174';
wwv_flow_imp.g_varchar2_table(4) := '7572655F70616420284D4954292E0A202A0A202A205468652076616C756520697320616E20696D61676520646174612055524C2E205768617420746865207061642073686F7773206973207061696E7465642066726F6D207468726565206C6179657273';
wwv_flow_imp.g_varchar2_table(5) := '2C20696E2074686973206F726465723A0A202A2020206261736520202061206C6F616465642076616C75652028696D616765292C20756E74696C20436C656172206F7220556E646F2072656D6F7665732069740A202A2020207479706564202061207479';
wwv_flow_imp.g_varchar2_table(6) := '706564206E616D652C20647261776E20696E20612068616E6477726974696E6720666F6E7420287265706C616365732064726177696E67290A202A20202070616420202020746865207374726F6B657320647261776E2077697468207369676E61747572';
wwv_flow_imp.g_varchar2_table(7) := '655F7061640A202A205468652063616E76617320697473656C66207374617973207472616E73706172656E743B2074686520706170657220636F6C6F72206973204353532C20616E6420616464656420746F2074686520696D616765206F6E6C79207768';
wwv_flow_imp.g_varchar2_table(8) := '656E20736176696E672E0A202A0A202A20617065782E6974656D28206E616D6520293A2067657456616C756528292C2073657456616C756528206461746155726C20292C206973456D70747928292C20656E61626C6528292C2064697361626C6528292C';
wwv_flow_imp.g_varchar2_table(9) := '20736574466F637573546F28292E0A202A2074656368726576782E7369676E61747572655061642E67657428206E616D6520292E73657450656E28207B20636F6C6F723A202223623332363165222C2077696474683A2022626F6C6422207D2029206368';
wwv_flow_imp.g_varchar2_table(10) := '616E676573207468652070656E2066726F6D20636F64652E0A202A204576656E7473206F6E20746865206974656D3A206368616E67652C2074782D7369676E61747572657061642D626567696E2C2074782D7369676E61747572657061642D636C656172';
wwv_flow_imp.g_varchar2_table(11) := '2E0A202A2F0A282066756E6374696F6E2820242C20617065782029207B0A202020202275736520737472696374223B0A0A20202020636F6E7374206E73203D2077696E646F772E7465636872657678203D2077696E646F772E7465636872657678207C7C';
wwv_flow_imp.g_varchar2_table(12) := '207B7D2C0A2020202020202020574944544853203D207B2066696E653A205B20302E342C20312E36205D2C206D656469756D3A205B20302E372C20322E36205D2C20626F6C643A205B20312E322C20332E38205D207D2C0A202020202020202053435249';
wwv_flow_imp.g_varchar2_table(13) := '50545F464F4E54203D20225C225365676F65205363726970745C222C205C22427275736820536372697074204D545C222C205C22536E656C6C20526F756E6468616E645C222C205C224170706C65204368616E636572795C222C205C2255525720436861';
wwv_flow_imp.g_varchar2_table(14) := '6E63657279204C5C222C2063757273697665222C0A20202020202020204C494E455F4154203D20302E37322C202F2F207369676E6174757265206C696E652C2061732061207368617265206F662074686520706164206865696768743B20746865204353';
wwv_flow_imp.g_varchar2_table(15) := '532075736573207468652073616D652076616C75650A2020202020202020444154415F55524C203D202F5E646174613A696D6167655C2F28706E677C6A7065677C7376675C2B786D6C293B6261736536342C5B412D5A612D7A302D392B2F3D5D2B242F3B';
wwv_flow_imp.g_varchar2_table(16) := '0A0A2020202066756E6374696F6E20656C28207461672C20636C732C20746578742029207B0A2020202020202020636F6E73742065203D20646F63756D656E742E637265617465456C656D656E74282074616720293B0A20202020202020206966202820';
wwv_flow_imp.g_varchar2_table(17) := '636C732029207B20652E636C6173734E616D65203D20636C733B207D0A202020202020202069662028207465787420213D206E756C6C2029207B20652E74657874436F6E74656E74203D20746578743B207D0A202020202020202072657475726E20653B';
wwv_flow_imp.g_varchar2_table(18) := '0A202020207D0A0A2020202066756E6374696F6E20627574746F6E2820636C732C2069636F6E2C206C6162656C2029207B0A2020202020202020636F6E73742062203D20656C282022627574746F6E222C202274782D5369672D62746E2022202B20636C';
wwv_flow_imp.g_varchar2_table(19) := '7320292C0A20202020202020202020202069203D20656C2820227370616E222C202266612022202B2069636F6E20293B0A2020202020202020622E74797065203D2022627574746F6E223B0A2020202020202020692E7365744174747269627574652820';
wwv_flow_imp.g_varchar2_table(20) := '22617269612D68696464656E222C2022747275652220293B0A2020202020202020622E617070656E642820692C20656C2820227370616E222C206E756C6C2C206C6162656C202920293B0A202020202020202072657475726E20623B0A202020207D0A0A';
wwv_flow_imp.g_varchar2_table(21) := '202020202F2F20736D616C6C6573742072656374616E676C6520686F6C64696E6720616C6C206E6F6E2D7472616E73706172656E7420706978656C732C206F72206E756C6C0A2020202066756E6374696F6E20696E6B426F756E6473282063616E766173';
wwv_flow_imp.g_varchar2_table(22) := '2029207B0A2020202020202020636F6E73742077203D2063616E7661732E77696474682C2068203D2063616E7661732E6865696768743B0A202020202020202069662028202177207C7C2021682029207B2072657475726E206E756C6C3B207D0A202020';
wwv_flow_imp.g_varchar2_table(23) := '2020202020636F6E73742064203D2063616E7661732E676574436F6E7465787428202232642220292E676574496D616765446174612820302C20302C20772C206820292E646174613B0A20202020202020206C6574207831203D20772C207931203D2068';
wwv_flow_imp.g_varchar2_table(24) := '2C207832203D202D312C207932203D202D313B0A2020202020202020666F722028206C65742079203D20303B2079203C20683B20792B2B2029207B0A202020202020202020202020666F722028206C65742078203D20303B2078203C20773B20782B2B20';
wwv_flow_imp.g_varchar2_table(25) := '29207B0A202020202020202020202020202020206966202820645B20282079202A2077202B20782029202A2034202B2033205D203E20382029207B0A2020202020202020202020202020202020202020696620282078203C2078312029207B207831203D';
wwv_flow_imp.g_varchar2_table(26) := '20783B207D0A2020202020202020202020202020202020202020696620282078203E2078322029207B207832203D20783B207D0A2020202020202020202020202020202020202020696620282079203C2079312029207B207931203D20793B207D0A2020';
wwv_flow_imp.g_varchar2_table(27) := '202020202020202020202020202020202020696620282079203E2079322029207B207932203D20793B207D0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A202020202020202072657475726E';
wwv_flow_imp.g_varchar2_table(28) := '207832203C2030203F206E756C6C203A207B20783A2078312C20793A2079312C20773A207832202D207831202B20312C20683A207932202D207931202B2031207D3B0A202020207D0A0A20202020636C61737320506164207B0A2020202020202020636F';
wwv_flow_imp.g_varchar2_table(29) := '6E7374727563746F7228206974656D4E616D652C206F7074696F6E732029207B0A202020202020202020202020746869732E6E616D65203D206974656D4E616D653B0A202020202020202020202020746869732E6F203D206F7074696F6E733B0A202020';
wwv_flow_imp.g_varchar2_table(30) := '202020202020202020746869732E696E707574203D20646F63756D656E742E676574456C656D656E744279496428206974656D4E616D6520293B0A202020202020202020202020746869732E77726170203D20646F63756D656E742E676574456C656D65';
wwv_flow_imp.g_varchar2_table(31) := '6E744279496428206974656D4E616D65202B20225F7369672220293B0A202020202020202020202020746869732E6665617475726573203D20537472696E6728206F7074696F6E732E6665617475726573207C7C20222220292E73706C69742820223A22';
wwv_flow_imp.g_varchar2_table(32) := '20293B0A202020202020202020202020746869732E7479706564203D2022223B0A202020202020202020202020746869732E62617365203D206E756C6C3B0A202020202020202020202020746869732E64697361626C6564203D2066616C73653B0A2020';
wwv_flow_imp.g_varchar2_table(33) := '20202020202020202020746869732E6377203D20746869732E6368203D20303B0A202020202020202020202020746869732E6275696C6428293B0A0A202020202020202020202020636F6E73742077203D205749445448535B206F7074696F6E732E7065';
wwv_flow_imp.g_varchar2_table(34) := '6E5769647468205D207C7C205749445448532E6D656469756D3B0A202020202020202020202020746869732E706164203D206E65772077696E646F772E5369676E61747572655061642820746869732E63616E7661732C204F626A6563742E6173736967';
wwv_flow_imp.g_varchar2_table(35) := '6E28207B0A2020202020202020202020202020202070656E436F6C6F723A206F7074696F6E732E70656E436F6C6F72207C7C202223316232613461222C0A202020202020202020202020202020206D696E57696474683A20775B2030205D2C0A20202020';
wwv_flow_imp.g_varchar2_table(36) := '2020202020202020202020206D617857696474683A20775B2031205D2C0A202020202020202020202020202020206261636B67726F756E64436F6C6F723A20227267626128302C302C302C3029222C0A202020202020202020202020202020202F2F2063';
wwv_flow_imp.g_varchar2_table(37) := '726F7070696E672072656164732074686520706978656C73206261636B2061667465722065616368207374726F6B650A2020202020202020202020202020202063616E766173436F6E746578744F7074696F6E733A207B2077696C6C5265616446726571';
wwv_flow_imp.g_varchar2_table(38) := '75656E746C793A2074727565207D0A2020202020202020202020207D2C206F7074696F6E732E7061644F7074696F6E73202920293B0A202020202020202020202020746869732E7061642E6164644576656E744C697374656E6572282022626567696E53';
wwv_flow_imp.g_varchar2_table(39) := '74726F6B65222C202829203D3E207B0A202020202020202020202020202020206966202820746869732E74797065642029207B20746869732E73657454797065642820222220293B20746869732E7061642E636C65617228293B207D0A20202020202020';
wwv_flow_imp.g_varchar2_table(40) := '202020202020202020696620282021746869732E7061642E746F4461746128292E6C656E6774682029207B20746869732E726566203D207B20773A20746869732E63772C20683A20746869732E6368207D3B207D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(41) := '20746869732E777261702E636C6173734C6973742E61646428202269732D64726177696E672220293B0A202020202020202020202020202020206966202820746869732E706C616365686F6C6465722029207B20746869732E706C616365686F6C646572';
wwv_flow_imp.g_varchar2_table(42) := '2E68696464656E203D20747275653B207D0A20202020202020202020202020202020617065782E6576656E742E747269676765722820746869732E696E7075742C202274782D7369676E61747572657061642D626567696E2220293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(43) := '20202020207D20293B0A202020202020202020202020746869732E7061642E6164644576656E744C697374656E6572282022656E645374726F6B65222C202829203D3E207B0A20202020202020202020202020202020746869732E777261702E636C6173';
wwv_flow_imp.g_varchar2_table(44) := '734C6973742E72656D6F766528202269732D64726177696E672220293B0A20202020202020202020202020202020746869732E7361766528293B0A2020202020202020202020207D20293B0A202020202020202020202020746869732E70656E57696474';
wwv_flow_imp.g_varchar2_table(45) := '68203D205749445448535B206F7074696F6E732E70656E5769647468205D203F206F7074696F6E732E70656E5769647468203A20226D656469756D223B0A202020202020202020202020746869732E73657450656E28207B7D20293B0A0A202020202020';
wwv_flow_imp.g_varchar2_table(46) := '202020202020746869732E726573697A6528293B0A202020202020202020202020696620282077696E646F772E526573697A654F627365727665722029207B206E657720526573697A654F6273657276657228202829203D3E20746869732E726573697A';
wwv_flow_imp.g_varchar2_table(47) := '65282920292E6F6273657276652820746869732E6172656120293B207D0A2020202020202020202020206966202820746869732E696E7075742E76616C75652029207B20746869732E6C6F61642820746869732E696E7075742E76616C756520293B207D';
wwv_flow_imp.g_varchar2_table(48) := '0A202020202020202020202020746869732E75706461746528293B0A20202020202020207D0A0A20202020202020206275696C642829207B0A202020202020202020202020636F6E7374206F203D20746869732E6F2C206C6162656C203D20646F63756D';
wwv_flow_imp.g_varchar2_table(49) := '656E742E676574456C656D656E74427949642820746869732E6E616D65202B20225F4C4142454C2220293B0A202020202020202020202020746869732E61726561203D20656C282022646976222C202274782D5369672D617265612220293B0A20202020';
wwv_flow_imp.g_varchar2_table(50) := '202020202020202069662028206F2E73697A696E67203D3D3D20226669786564222029207B0A20202020202020202020202020202020746869732E617265612E7374796C652E686569676874203D2028206F2E686569676874207C7C203230302029202B';
wwv_flow_imp.g_varchar2_table(51) := '20227078223B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020202F2F2048656967687420697320746865206D6178696D756D3B206E6172726F7765722070616473206B656570206120323A31207368617065';
wwv_flow_imp.g_varchar2_table(52) := '2028435353207365747320746865206D696E696D756D290A20202020202020202020202020202020746869732E617265612E636C6173734C6973742E61646428202274782D5369672D617265612D2D726573706F6E736976652220293B0A202020202020';
wwv_flow_imp.g_varchar2_table(53) := '20202020202020202020746869732E617265612E7374796C652E6D6178486569676874203D2028206F2E686569676874207C7C203230302029202B20227078223B0A2020202020202020202020207D0A20202020202020202020202069662028206F2E62';
wwv_flow_imp.g_varchar2_table(54) := '61636B67726F756E642029207B20746869732E617265612E7374796C652E73657450726F70657274792820222D2D74782D7369672D7061706572222C206F2E6261636B67726F756E6420293B207D0A202020202020202020202020746869732E63616E76';
wwv_flow_imp.g_varchar2_table(55) := '6173203D20656C28202263616E766173222C202274782D5369672D63616E7661732220293B0A202020202020202020202020746869732E63616E7661732E736574417474726962757465282022726F6C65222C2022696D672220293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(56) := '2020202020746869732E63616E7661732E746162496E646578203D202D313B0A202020202020202020202020746869732E63616E7661732E736574417474726962757465282022617269612D6C6162656C222C2028206C6162656C203F206C6162656C2E';
wwv_flow_imp.g_varchar2_table(57) := '74657874436F6E74656E742E7472696D2829202B20223A2022203A2022222029202B20227369676E6174757265207061642E204472617720776974682061206D6F7573652C2066696E676572206F722070656E220A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(58) := '202B202820746869732E68617328202274797065222029203F20222C206F722063686F6F7365205479706520696E73746561642E22203A20222E22202920293B0A202020202020202020202020746869732E617265612E617070656E642820746869732E';
wwv_flow_imp.g_varchar2_table(59) := '63616E76617320293B0A2020202020202020202020206966202820746869732E6861732820226C696E652220292029207B0A20202020202020202020202020202020636F6E7374206C696E65203D20656C282022646976222C202274782D5369672D6C69';
wwv_flow_imp.g_varchar2_table(60) := '6E652220293B0A202020202020202020202020202020206C696E652E736574417474726962757465282022617269612D68696464656E222C2022747275652220293B0A20202020202020202020202020202020746869732E617265612E617070656E6428';
wwv_flow_imp.g_varchar2_table(61) := '206C696E6520293B0A20202020202020202020202020202020746869732E617265612E636C6173734C6973742E6164642820226861732D6C696E652220293B0A2020202020202020202020207D0A20202020202020202020202069662028206F2E706C61';
wwv_flow_imp.g_varchar2_table(62) := '6365686F6C6465722029207B0A20202020202020202020202020202020746869732E706C616365686F6C646572203D20656C282022646976222C202274782D5369672D706C616365686F6C646572222C206F2E706C616365686F6C64657220293B0A2020';
wwv_flow_imp.g_varchar2_table(63) := '2020202020202020202020202020746869732E706C616365686F6C6465722E736574417474726962757465282022617269612D68696464656E222C2022747275652220293B0A20202020202020202020202020202020746869732E617265612E61707065';
wwv_flow_imp.g_varchar2_table(64) := '6E642820746869732E706C616365686F6C64657220293B0A2020202020202020202020207D0A0A202020202020202020202020636F6E737420626172203D20656C282022646976222C202274782D5369672D6261722220293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(65) := '20206966202820746869732E686173282022747970652220292029207B0A20202020202020202020202020202020746869732E7479706542746E203D20627574746F6E28202274782D5369672D7479706542746E222C202266612D6B6579626F6172642D';
wwv_flow_imp.g_varchar2_table(66) := '6F222C20225479706520696E73746561642220293B0A20202020202020202020202020202020746869732E7479706542746E2E736574417474726962757465282022617269612D657870616E646564222C202266616C73652220293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(67) := '202020202020202020746869732E7479706542746E2E6164644576656E744C697374656E6572282022636C69636B222C202829203D3E20746869732E746F67676C6554797065282920293B0A202020202020202020202020202020206261722E61707065';
wwv_flow_imp.g_varchar2_table(68) := '6E642820746869732E7479706542746E20293B0A2020202020202020202020207D0A2020202020202020202020206966202820746869732E68617328202270656E2220292029207B206261722E617070656E642820746869732E6275696C6450656E2829';
wwv_flow_imp.g_varchar2_table(69) := '20293B207D0A202020202020202020202020636F6E737420616374696F6E73203D20656C282022646976222C202274782D5369672D616374696F6E732220293B0A2020202020202020202020206966202820746869732E686173282022756E646F222029';
wwv_flow_imp.g_varchar2_table(70) := '2029207B0A20202020202020202020202020202020746869732E756E646F42746E203D20627574746F6E28202274782D5369672D756E646F222C202266612D756E646F222C2022556E646F2220293B0A2020202020202020202020202020202074686973';
wwv_flow_imp.g_varchar2_table(71) := '2E756E646F42746E2E6164644576656E744C697374656E6572282022636C69636B222C202829203D3E20746869732E756E646F282920293B0A20202020202020202020202020202020616374696F6E732E617070656E642820746869732E756E646F4274';
wwv_flow_imp.g_varchar2_table(72) := '6E20293B0A2020202020202020202020207D0A2020202020202020202020206966202820746869732E686173282022636C6561722220292029207B0A20202020202020202020202020202020746869732E636C65617242746E203D20627574746F6E2820';
wwv_flow_imp.g_varchar2_table(73) := '2274782D5369672D636C656172222C202266612D74696D6573222C2022436C6561722220293B0A20202020202020202020202020202020746869732E636C65617242746E2E6164644576656E744C697374656E6572282022636C69636B222C202829203D';
wwv_flow_imp.g_varchar2_table(74) := '3E20746869732E636C656172282074727565202920293B0A20202020202020202020202020202020616374696F6E732E617070656E642820746869732E636C65617242746E20293B0A2020202020202020202020207D0A20202020202020202020202069';
wwv_flow_imp.g_varchar2_table(75) := '66202820616374696F6E732E6368696C6472656E2E6C656E6774682029207B206261722E617070656E642820616374696F6E7320293B207D0A0A202020202020202020202020746869732E777261702E70726570656E642820746869732E617265612029';
wwv_flow_imp.g_varchar2_table(76) := '3B0A20202020202020202020202069662028206261722E6368696C6472656E2E6C656E6774682029207B20746869732E617265612E6166746572282062617220293B207D0A2020202020202020202020206966202820746869732E7479706542746E2029';
wwv_flow_imp.g_varchar2_table(77) := '207B0A20202020202020202020202020202020746869732E74797065526F77203D20656C282022646976222C202274782D5369672D74797065526F772220293B0A20202020202020202020202020202020746869732E74797065526F772E68696464656E';
wwv_flow_imp.g_varchar2_table(78) := '203D20747275653B0A20202020202020202020202020202020746869732E74797065496E707574203D20656C282022696E707574222C202274782D5369672D74797065496E7075742220293B0A20202020202020202020202020202020746869732E7479';
wwv_flow_imp.g_varchar2_table(79) := '7065496E7075742E74797065203D202274657874223B0A20202020202020202020202020202020746869732E74797065496E7075742E6D61784C656E677468203D2036303B0A20202020202020202020202020202020746869732E74797065496E707574';
wwv_flow_imp.g_varchar2_table(80) := '2E6175746F636F6D706C657465203D20226E616D65223B0A20202020202020202020202020202020746869732E74797065496E7075742E706C616365686F6C646572203D20225479706520796F75722066756C6C206E616D65223B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(81) := '2020202020202020746869732E74797065496E7075742E736574417474726962757465282022617269612D6C6162656C222C20225479706520796F7572206E616D6520746F207369676E2220293B0A20202020202020202020202020202020746869732E';
wwv_flow_imp.g_varchar2_table(82) := '74797065496E7075742E6964203D20746869732E6E616D65202B20225F7479706564223B0A20202020202020202020202020202020746869732E74797065496E7075742E6164644576656E744C697374656E6572282022696E707574222C202829203D3E';
wwv_flow_imp.g_varchar2_table(83) := '207B0A2020202020202020202020202020202020202020746869732E62617365203D206E756C6C3B0A2020202020202020202020202020202020202020746869732E73657454797065642820746869732E74797065496E7075742E76616C75652E747269';
wwv_flow_imp.g_varchar2_table(84) := '6D28292C207472756520293B0A2020202020202020202020202020202020202020746869732E72657061696E7428205B5D20293B0A2020202020202020202020202020202020202020746869732E75706461746528293B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(85) := '2020202020202020636C65617254696D656F75742820746869732E7479706554696D657220293B0A2020202020202020202020202020202020202020746869732E7479706554696D6572203D2073657454696D656F757428202829203D3E20746869732E';
wwv_flow_imp.g_varchar2_table(86) := '7361766528292C2033303020293B0A202020202020202020202020202020207D20293B0A20202020202020202020202020202020746869732E74797065526F772E617070656E642820746869732E74797065496E70757420293B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(87) := '202020202020206261722E61667465722820746869732E74797065526F7720293B0A2020202020202020202020207D0A20202020202020207D0A0A20202020202020206861732820666561747572652029207B2072657475726E20746869732E66656174';
wwv_flow_imp.g_varchar2_table(88) := '757265732E696E636C7564657328206665617475726520293B207D0A0A20202020202020202F2F2050656E2043686F696365733A20636F6C6F7220737761746368657320616E64206C696E652073697A65733B207369676E61747572655F706164206B65';
wwv_flow_imp.g_varchar2_table(89) := '657073207468656D20706572207374726F6B650A20202020202020206275696C6450656E2829207B0A202020202020202020202020636F6E73742067726F7570203D20656C282022646976222C202274782D5369672D70656E2220292C0A202020202020';
wwv_flow_imp.g_varchar2_table(90) := '202020202020202020207374617274203D20746869732E6F2E70656E436F6C6F72207C7C202223316232613461222C0A20202020202020202020202020202020636F6C6F7273203D205B207374617274205D2E636F6E6361742820537472696E67282074';
wwv_flow_imp.g_varchar2_table(91) := '6869732E6F2E70656E436F6C6F7273207C7C20222220292E73706C69742820222C2220292E6D6170282063203D3E20632E7472696D282920290A20202020202020202020202020202020202020202E66696C746572282063203D3E206320262620632E74';
wwv_flow_imp.g_varchar2_table(92) := '6F4C6F77657243617365282920213D3D2073746172742E746F4C6F776572436173652829202920293B0A20202020202020202020202067726F75702E736574417474726962757465282022726F6C65222C202267726F75702220293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(93) := '202020202067726F75702E736574417474726962757465282022617269612D6C6162656C222C202250656E2220293B0A202020202020202020202020746869732E7377617463686573203D20636F6C6F72732E6D6170282063203D3E207B0A2020202020';
wwv_flow_imp.g_varchar2_table(94) := '2020202020202020202020636F6E73742062203D20656C282022627574746F6E222C202274782D5369672D7377617463682220293B0A20202020202020202020202020202020622E74797065203D2022627574746F6E223B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(95) := '2020202020622E7374796C652E73657450726F70657274792820222D2D74782D7369672D737761746368222C206320293B0A20202020202020202020202020202020622E646174617365742E636F6C6F72203D20633B0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(96) := '202020622E7469746C65203D202250656E20636F6C6F722022202B20633B0A20202020202020202020202020202020622E736574417474726962757465282022617269612D6C6162656C222C202250656E20636F6C6F722022202B206320293B0A202020';
wwv_flow_imp.g_varchar2_table(97) := '20202020202020202020202020622E6164644576656E744C697374656E6572282022636C69636B222C202829203D3E20746869732E73657450656E28207B20636F6C6F723A2063207D202920293B0A202020202020202020202020202020207265747572';
wwv_flow_imp.g_varchar2_table(98) := '6E20623B0A2020202020202020202020207D20293B0A202020202020202020202020746869732E73697A6573203D204F626A6563742E6B657973282057494454485320292E6D6170282077203D3E207B0A20202020202020202020202020202020636F6E';
wwv_flow_imp.g_varchar2_table(99) := '73742062203D20656C282022627574746F6E222C202274782D5369672D73697A652074782D5369672D73697A652D2D22202B207720292C0A20202020202020202020202020202020202020206C6162656C203D20772E63686172417428203020292E746F';
wwv_flow_imp.g_varchar2_table(100) := '5570706572436173652829202B20772E736C6963652820312029202B2022206C696E65223B0A20202020202020202020202020202020622E74797065203D2022627574746F6E223B0A20202020202020202020202020202020622E646174617365742E77';
wwv_flow_imp.g_varchar2_table(101) := '69647468203D20773B0A20202020202020202020202020202020622E7469746C65203D206C6162656C3B0A20202020202020202020202020202020622E736574417474726962757465282022617269612D6C6162656C222C206C6162656C20293B0A2020';
wwv_flow_imp.g_varchar2_table(102) := '2020202020202020202020202020622E617070656E642820656C2820227370616E222C202274782D5369672D73697A65446F7422202920293B0A20202020202020202020202020202020622E6164644576656E744C697374656E6572282022636C69636B';
wwv_flow_imp.g_varchar2_table(103) := '222C202829203D3E20746869732E73657450656E28207B2077696474683A2077207D202920293B0A2020202020202020202020202020202072657475726E20623B0A2020202020202020202020207D20293B0A202020202020202020202020636F6E7374';
wwv_flow_imp.g_varchar2_table(104) := '20736570203D20656C2820227370616E222C202274782D5369672D7365702220293B0A2020202020202020202020207365702E736574417474726962757465282022617269612D68696464656E222C2022747275652220293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(105) := '202067726F75702E617070656E6428202E2E2E746869732E73776174636865732C207365702C202E2E2E746869732E73697A657320293B0A20202020202020202020202072657475726E2067726F75703B0A20202020202020207D0A0A20202020202020';
wwv_flow_imp.g_varchar2_table(106) := '202F2F207468652070656E20666F7220746865206E657874207374726F6B65732028616E642061207479706564206E616D65293A207B20636F6C6F722C2077696474683A2066696E65207C206D656469756D207C20626F6C64207D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(107) := '73657450656E282070656E2029207B0A202020202020202020202020696620282070656E2E636F6C6F722029207B20746869732E7061642E70656E436F6C6F72203D2070656E2E636F6C6F723B207D0A202020202020202020202020696620282070656E';
wwv_flow_imp.g_varchar2_table(108) := '2E7769647468202626205749445448535B2070656E2E7769647468205D2029207B0A20202020202020202020202020202020746869732E70656E5769647468203D2070656E2E77696474683B0A20202020202020202020202020202020746869732E7061';
wwv_flow_imp.g_varchar2_table(109) := '642E6D696E5769647468203D205749445448535B2070656E2E7769647468205D5B2030205D3B0A20202020202020202020202020202020746869732E7061642E6D61785769647468203D205749445448535B2070656E2E7769647468205D5B2031205D3B';
wwv_flow_imp.g_varchar2_table(110) := '0A2020202020202020202020207D0A2020202020202020202020202820746869732E7377617463686573207C7C205B5D20292E666F7245616368282062203D3E20622E736574417474726962757465282022617269612D70726573736564222C20537472';
wwv_flow_imp.g_varchar2_table(111) := '696E672820622E646174617365742E636F6C6F722E746F4C6F776572436173652829203D3D3D20746869732E7061642E70656E436F6C6F722E746F4C6F7765724361736528292029202920293B0A2020202020202020202020202820746869732E73697A';
wwv_flow_imp.g_varchar2_table(112) := '6573207C7C205B5D20292E666F7245616368282062203D3E20622E736574417474726962757465282022617269612D70726573736564222C20537472696E672820622E646174617365742E7769647468203D3D3D20746869732E70656E57696474682029';
wwv_flow_imp.g_varchar2_table(113) := '202920293B0A202020202020202020202020746869732E777261702E7374796C652E73657450726F70657274792820222D2D74782D7369672D70656E222C20746869732E7061642E70656E436F6C6F7220293B0A20202020202020202020202069662028';
wwv_flow_imp.g_varchar2_table(114) := '20746869732E74797065642026262070656E2E636F6C6F722029207B0A20202020202020202020202020202020746869732E72657061696E7428205B5D20293B0A20202020202020202020202020202020746869732E7361766528293B0A202020202020';
wwv_flow_imp.g_varchar2_table(115) := '2020202020207D0A20202020202020207D0A0A202020202020202073657454797065642820746578742C206B656570496E7075742029207B0A202020202020202020202020746869732E7479706564203D20746578743B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(116) := '6966202820746869732E74797065496E70757420262620216B656570496E7075742029207B20746869732E74797065496E7075742E76616C7565203D20746578743B207D0A20202020202020207D0A0A2020202020202020746F67676C65547970652820';
wwv_flow_imp.g_varchar2_table(117) := '6F70656E2029207B0A202020202020202020202020636F6E73742073686F77203D206F70656E20213D206E756C6C203F206F70656E203A20746869732E74797065526F772E68696464656E3B0A202020202020202020202020746869732E74797065526F';
wwv_flow_imp.g_varchar2_table(118) := '772E68696464656E203D202173686F773B0A202020202020202020202020746869732E7479706542746E2E736574417474726962757465282022617269612D657870616E646564222C20537472696E67282073686F77202920293B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(119) := '20202020696620282073686F772029207B20746869732E74797065496E7075742E666F63757328293B207D0A20202020202020207D0A0A20202020202020202F2F20486F77207374726F6B6573206D61702066726F6D20746865207265666572656E6365';
wwv_flow_imp.g_varchar2_table(120) := '2073697A652028746865207061642073697A65207768656E2074686579207765726520666972737420647261776E2920746F2061207720782068207061643A0A20202020202020202F2F207363616C656420746F2066697420616E642063656E74657265';
wwv_flow_imp.g_varchar2_table(121) := '642C20736F2061207369676E6174757265207375727669766573206E6172726F77696E6720616E6420776964656E696E6720746865207061676520756E6368616E6765642E0A2020202020202020766965772820772C20682029207B0A20202020202020';
wwv_flow_imp.g_varchar2_table(122) := '2020202020636F6E73742072203D20746869732E726566207C7C207B20772C2068207D2C2073203D204D6174682E6D696E282077202F20722E772C2068202F20722E6820293B0A20202020202020202020202072657475726E207B20732C2064783A2028';
wwv_flow_imp.g_varchar2_table(123) := '2077202D20722E77202A20732029202F20322C2064793A20282068202D20722E68202A20732029202F2032207D3B0A20202020202020207D0A0A20202020202020202F2F2063616E76617320706978656C7320666F6C6C6F772074686520656C656D656E';
wwv_flow_imp.g_varchar2_table(124) := '742073697A6520616E64207468652064657669636520706978656C20726174696F3B2074686520636F6E74656E74206973207363616C656420616E64207061696E74656420616761696E0A2020202020202020726573697A652829207B0A202020202020';
wwv_flow_imp.g_varchar2_table(125) := '202020202020636F6E737420647072203D204D6174682E6D6178282077696E646F772E646576696365506978656C526174696F207C7C20312C203120292C0A2020202020202020202020202020202077203D20746869732E617265612E636C69656E7457';
wwv_flow_imp.g_varchar2_table(126) := '696474682C0A2020202020202020202020202020202068203D20746869732E617265612E636C69656E744865696768743B0A20202020202020202020202069662028202177207C7C202168207C7C20282077203D3D3D20746869732E6377202626206820';
wwv_flow_imp.g_varchar2_table(127) := '3D3D3D20746869732E636820262620647072203D3D3D20746869732E64707220292029207B2072657475726E3B207D0A2020202020202020202020206C65742064617461203D20746869732E7061642E746F4461746128292E736C69636528293B0A2020';
wwv_flow_imp.g_varchar2_table(128) := '20202020202020202020696620282021646174612E6C656E677468207C7C2021746869732E7265662029207B0A20202020202020202020202020202020746869732E726566203D207B20772C2068207D3B0A2020202020202020202020207D20656C7365';
wwv_flow_imp.g_varchar2_table(129) := '2069662028207720213D3D20746869732E6377207C7C206820213D3D20746869732E63682029207B0A20202020202020202020202020202020636F6E73742066726F6D203D20746869732E766965772820746869732E63772C20746869732E636820292C';
wwv_flow_imp.g_varchar2_table(130) := '20746F203D20746869732E766965772820772C206820293B0A2020202020202020202020202020202064617461203D20646174612E6D6170282067203D3E204F626A6563742E61737369676E28207B7D2C20672C207B20706F696E74733A20672E706F69';
wwv_flow_imp.g_varchar2_table(131) := '6E74732E6D6170282070203D3E204F626A6563742E61737369676E28207B7D2C20702C207B0A2020202020202020202020202020202020202020783A202820702E78202D2066726F6D2E64782029202F2066726F6D2E73202A20746F2E73202B20746F2E';
wwv_flow_imp.g_varchar2_table(132) := '64782C0A2020202020202020202020202020202020202020793A202820702E79202D2066726F6D2E64792029202F2066726F6D2E73202A20746F2E73202B20746F2E64790A202020202020202020202020202020207D20292029207D202920293B0A2020';
wwv_flow_imp.g_varchar2_table(133) := '202020202020202020207D0A202020202020202020202020746869732E63616E7661732E7769647468203D204D6174682E726F756E64282077202A2064707220293B0A202020202020202020202020746869732E63616E7661732E686569676874203D20';
wwv_flow_imp.g_varchar2_table(134) := '4D6174682E726F756E64282068202A2064707220293B0A202020202020202020202020746869732E63616E7661732E7374796C652E7769647468203D2077202B20227078223B0A202020202020202020202020746869732E63616E7661732E7374796C65';
wwv_flow_imp.g_varchar2_table(135) := '2E686569676874203D2068202B20227078223B0A202020202020202020202020746869732E63616E7661732E676574436F6E7465787428202232642220292E7363616C6528206470722C2064707220293B0A202020202020202020202020746869732E63';
wwv_flow_imp.g_varchar2_table(136) := '77203D20773B0A202020202020202020202020746869732E6368203D20683B0A202020202020202020202020746869732E647072203D206470723B0A202020202020202020202020746869732E72657061696E7428206461746120293B0A202020202020';
wwv_flow_imp.g_varchar2_table(137) := '20207D0A0A202020202020202072657061696E7428207374726F6B65732029207B0A202020202020202020202020636F6E737420637478203D20746869732E63616E7661732E676574436F6E7465787428202232642220293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(138) := '2020746869732E7061642E636C65617228293B0A2020202020202020202020206966202820746869732E6261736520262620746869732E626173652E696D672E636F6D706C65746520262620746869732E626173652E696D672E6E61747572616C576964';
wwv_flow_imp.g_varchar2_table(139) := '74682029207B0A20202020202020202020202020202020636F6E73742072203D20746869732E626173655265637428293B0A202020202020202020202020202020206374782E64726177496D6167652820746869732E626173652E696D672C20722E782C';
wwv_flow_imp.g_varchar2_table(140) := '20722E792C20722E772C20722E6820293B0A2020202020202020202020207D0A2020202020202020202020206966202820746869732E74797065642029207B20746869732E647261775479706564282063747820293B207D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(141) := '2069662028207374726F6B6573202626207374726F6B65732E6C656E6774682029207B20746869732E7061642E66726F6D4461746128207374726F6B65732C207B20636C6561723A2066616C7365207D20293B207D0A20202020202020207D0A0A202020';
wwv_flow_imp.g_varchar2_table(142) := '20202020202F2F2061206C6F6164656420696D6167652C207363616C656420646F776E20746F20666974207468652070616420616E642063656E74657265640A202020202020202062617365526563742829207B0A202020202020202020202020636F6E';
wwv_flow_imp.g_varchar2_table(143) := '737420696D67203D20746869732E626173652E696D672C0A2020202020202020202020202020202073203D204D6174682E6D696E2820746869732E6377202F20696D672E6E61747572616C57696474682C20746869732E6368202F20696D672E6E617475';
wwv_flow_imp.g_varchar2_table(144) := '72616C4865696768742C203120292C0A2020202020202020202020202020202077203D20696D672E6E61747572616C5769647468202A20732C0A2020202020202020202020202020202068203D20696D672E6E61747572616C486569676874202A20733B';
wwv_flow_imp.g_varchar2_table(145) := '0A20202020202020202020202072657475726E207B20783A202820746869732E6377202D20772029202F20322C20793A202820746869732E6368202D20682029202F20322C20772C2068207D3B0A20202020202020207D0A0A2020202020202020747970';
wwv_flow_imp.g_varchar2_table(146) := '65644C61796F75742829207B0A202020202020202020202020636F6E737420637478203D20746869732E63616E7661732E676574436F6E7465787428202232642220293B0A2020202020202020202020206C65742073697A65203D204D6174682E6D696E';
wwv_flow_imp.g_varchar2_table(147) := '2820746869732E6368202A20302E34322C20363420293B0A2020202020202020202020206374782E666F6E74203D2073697A65202B202270782022202B205343524950545F464F4E543B0A2020202020202020202020202F2F206B6565707320636C6561';
wwv_flow_imp.g_varchar2_table(148) := '72206F6620746865206C696E6527732078206F6E20746865206C6566740A2020202020202020202020207768696C6520282073697A65203E203132202626206374782E6D656173757265546578742820746869732E747970656420292E7769647468203E';
wwv_flow_imp.g_varchar2_table(149) := '20746869732E6377202D203131322029207B0A2020202020202020202020202020202073697A65202D3D20323B0A202020202020202020202020202020206374782E666F6E74203D2073697A65202B202270782022202B205343524950545F464F4E543B';
wwv_flow_imp.g_varchar2_table(150) := '0A2020202020202020202020207D0A20202020202020202020202072657475726E207B2073697A652C20783A20746869732E6377202F20322C20793A20746869732E6861732820226C696E65222029203F20746869732E6368202A204C494E455F415420';
wwv_flow_imp.g_varchar2_table(151) := '2D2073697A65202A20302E3138203A20746869732E6368202F2032202B2073697A65202A20302E33207D3B0A20202020202020207D0A0A202020202020202064726177547970656428206374782029207B0A202020202020202020202020636F6E737420';
wwv_flow_imp.g_varchar2_table(152) := '74203D20746869732E74797065644C61796F757428293B0A2020202020202020202020206374782E7361766528293B0A2020202020202020202020206374782E666F6E74203D20742E73697A65202B202270782022202B205343524950545F464F4E543B';
wwv_flow_imp.g_varchar2_table(153) := '0A2020202020202020202020206374782E66696C6C5374796C65203D20746869732E7061642E70656E436F6C6F723B0A2020202020202020202020206374782E74657874416C69676E203D202263656E746572223B0A2020202020202020202020206374';
wwv_flow_imp.g_varchar2_table(154) := '782E74657874426173656C696E65203D2022616C7068616265746963223B0A2020202020202020202020206374782E66696C6C546578742820746869732E74797065642C20742E782C20742E7920293B0A2020202020202020202020206374782E726573';
wwv_flow_imp.g_varchar2_table(155) := '746F726528293B0A20202020202020207D0A0A20202020202020206973456D7074792829207B0A20202020202020202020202072657475726E2021746869732E626173652026262021746869732E747970656420262620746869732E7061642E746F4461';
wwv_flow_imp.g_varchar2_table(156) := '746128292E6C656E677468203D3D3D20303B0A20202020202020207D0A0A20202020202020207570646174652829207B0A202020202020202020202020636F6E737420656D707479203D20746869732E6973456D70747928293B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(157) := '202020746869732E777261702E636C6173734C6973742E746F67676C6528202269732D656D707479222C20656D70747920293B0A2020202020202020202020206966202820746869732E706C616365686F6C6465722029207B20746869732E706C616365';
wwv_flow_imp.g_varchar2_table(158) := '686F6C6465722E68696464656E203D2021656D7074793B207D0A2020202020202020202020205B20746869732E756E646F42746E2C20746869732E636C65617242746E205D2E666F7245616368282062203D3E207B206966202820622029207B20622E64';
wwv_flow_imp.g_varchar2_table(159) := '697361626C6564203D20656D707479207C7C20746869732E64697361626C65643B207D207D20293B0A20202020202020207D0A0A2020202020202020736176652829207B0A202020202020202020202020636F6E737420656D707479203D20746869732E';
wwv_flow_imp.g_varchar2_table(160) := '6973456D70747928293B0A202020202020202020202020746869732E696E7075742E76616C7565203D20656D707479203F202222203A20746869732E6578706F7274496D61676528293B0A2020202020202020202020202F2F20612022506C6561736520';
wwv_flow_imp.g_varchar2_table(161) := '7369676E22206572726F722066726F6D20616E206561726C696572207375626D6974206E6F206C6F6E676572206170706C6965730A202020202020202020202020696620282021656D7074792029207B20617065782E6D6573736167652E636C65617245';
wwv_flow_imp.g_varchar2_table(162) := '72726F72732820746869732E6E616D6520293B207D0A202020202020202020202020242820746869732E696E70757420292E747269676765722820226368616E67652220293B0A202020202020202020202020746869732E75706461746528293B0A2020';
wwv_flow_imp.g_varchar2_table(163) := '2020202020207D0A0A20202020202020206578706F7274496D6167652829207B0A202020202020202020202020636F6E737420666D74203D20746869732E6F2E666F726D61743B0A2020202020202020202020206966202820666D74203D3D3D20227376';
wwv_flow_imp.g_varchar2_table(164) := '67222029207B2072657475726E20746869732E6578706F727453766728293B207D0A202020202020202020202020636F6E737420737263203D20746869732E63616E7661733B0A2020202020202020202020206C65742072203D207B20783A20302C2079';
wwv_flow_imp.g_varchar2_table(165) := '3A20302C20773A207372632E77696474682C20683A207372632E686569676874207D3B0A2020202020202020202020206966202820746869732E6F2E7472696D2029207B0A20202020202020202020202020202020636F6E73742062203D20696E6B426F';
wwv_flow_imp.g_varchar2_table(166) := '756E6473282073726320292C20706164203D204D6174682E726F756E6428203130202A20746869732E64707220293B0A202020202020202020202020202020206966202820622029207B0A2020202020202020202020202020202020202020636F6E7374';
wwv_flow_imp.g_varchar2_table(167) := '2078203D204D6174682E6D61782820302C20622E78202D2070616420292C2079203D204D6174682E6D61782820302C20622E79202D2070616420293B0A202020202020202020202020202020202020202072203D207B20782C20792C20773A204D617468';
wwv_flow_imp.g_varchar2_table(168) := '2E6D696E28207372632E77696474682C20622E78202B20622E77202B207061642029202D20782C20683A204D6174682E6D696E28207372632E6865696768742C20622E79202B20622E68202B207061642029202D2079207D3B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(169) := '2020202020207D0A2020202020202020202020207D0A202020202020202020202020636F6E7374207363616C65203D204D6174682E6D696E2820312C202820746869732E6F2E6D61785769647468207C7C203630302029202F20722E7720292C0A202020';
wwv_flow_imp.g_varchar2_table(170) := '202020202020202020202020206F7574203D20646F63756D656E742E637265617465456C656D656E7428202263616E7661732220293B0A2020202020202020202020206F75742E7769647468203D204D6174682E6D61782820312C204D6174682E726F75';
wwv_flow_imp.g_varchar2_table(171) := '6E642820722E77202A207363616C65202920293B0A2020202020202020202020206F75742E686569676874203D204D6174682E6D61782820312C204D6174682E726F756E642820722E68202A207363616C65202920293B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(172) := '636F6E737420637478203D206F75742E676574436F6E7465787428202232642220292C0A202020202020202020202020202020207061706572203D20746869732E6F2E6261636B67726F756E64207C7C202820666D74203D3D3D20226A70656722203F20';
wwv_flow_imp.g_varchar2_table(173) := '222366666666666622203A206E756C6C20293B0A202020202020202020202020696620282070617065722029207B0A202020202020202020202020202020206374782E66696C6C5374796C65203D2070617065723B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(174) := '20206374782E66696C6C526563742820302C20302C206F75742E77696474682C206F75742E68656967687420293B0A2020202020202020202020207D0A2020202020202020202020206374782E64726177496D61676528207372632C20722E782C20722E';
wwv_flow_imp.g_varchar2_table(175) := '792C20722E772C20722E682C20302C20302C206F75742E77696474682C206F75742E68656967687420293B0A20202020202020202020202072657475726E206F75742E746F4461746155524C2820666D74203D3D3D20226A70656722203F2022696D6167';
wwv_flow_imp.g_varchar2_table(176) := '652F6A70656722203A2022696D6167652F706E67222C20302E393220293B0A20202020202020207D0A0A20202020202020202F2F207369676E61747572655F706164277320535647206F6620746865207374726F6B65732C207769746820746865207061';
wwv_flow_imp.g_varchar2_table(177) := '7065722C2061206C6F6164656420696D61676520616E642061207479706564206E616D652061646465640A20202020202020206578706F72745376672829207B0A202020202020202020202020636F6E7374204E53203D2022687474703A2F2F7777772E';
wwv_flow_imp.g_varchar2_table(178) := '77332E6F72672F323030302F737667222C0A20202020202020202020202020202020737667203D206E657720444F4D50617273657228292E706172736546726F6D537472696E672820746869732E7061642E746F53564728292C2022696D6167652F7376';
wwv_flow_imp.g_varchar2_table(179) := '672B786D6C2220292E646F63756D656E74456C656D656E742C0A202020202020202020202020202020206669727374203D207376672E66697273744368696C643B0A2020202020202020202020207376672E736574417474726962757465282022766965';
wwv_flow_imp.g_varchar2_table(180) := '77426F78222C20223020302022202B20746869732E6377202B20222022202B20746869732E636820293B0A2020202020202020202020207376672E7365744174747269627574652820227769647468222C20746869732E637720293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(181) := '20202020207376672E736574417474726962757465282022686569676874222C20746869732E636820293B0A2020202020202020202020206966202820746869732E6F2E6261636B67726F756E642029207B0A2020202020202020202020202020202063';
wwv_flow_imp.g_varchar2_table(182) := '6F6E73742072656374203D20646F63756D656E742E637265617465456C656D656E744E5328204E532C2022726563742220293B0A20202020202020202020202020202020726563742E7365744174747269627574652820227769647468222C2022313030';
wwv_flow_imp.g_varchar2_table(183) := '252220293B0A20202020202020202020202020202020726563742E736574417474726962757465282022686569676874222C2022313030252220293B0A20202020202020202020202020202020726563742E73657441747472696275746528202266696C';
wwv_flow_imp.g_varchar2_table(184) := '6C222C20746869732E6F2E6261636B67726F756E6420293B0A202020202020202020202020202020207376672E696E736572744265666F72652820726563742C20666972737420293B0A2020202020202020202020207D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(185) := '6966202820746869732E6261736520262620746869732E626173652E696D672E6E61747572616C57696474682029207B0A20202020202020202020202020202020636F6E73742072203D20746869732E626173655265637428292C20696D616765203D20';
wwv_flow_imp.g_varchar2_table(186) := '646F63756D656E742E637265617465456C656D656E744E5328204E532C2022696D6167652220293B0A20202020202020202020202020202020696D6167652E73657441747472696275746528202278222C20722E782E746F466978656428203220292029';
wwv_flow_imp.g_varchar2_table(187) := '3B0A20202020202020202020202020202020696D6167652E73657441747472696275746528202279222C20722E792E746F4669786564282032202920293B0A20202020202020202020202020202020696D6167652E736574417474726962757465282022';
wwv_flow_imp.g_varchar2_table(188) := '7769647468222C20722E772E746F4669786564282032202920293B0A20202020202020202020202020202020696D6167652E736574417474726962757465282022686569676874222C20722E682E746F4669786564282032202920293B0A202020202020';
wwv_flow_imp.g_varchar2_table(189) := '20202020202020202020696D6167652E73657441747472696275746528202268726566222C20746869732E626173652E75726C20293B0A202020202020202020202020202020207376672E696E736572744265666F72652820696D6167652C2066697273';
wwv_flow_imp.g_varchar2_table(190) := '7420293B0A2020202020202020202020207D0A2020202020202020202020206966202820746869732E74797065642029207B0A20202020202020202020202020202020636F6E73742074203D20746869732E74797065644C61796F757428292C20746578';
wwv_flow_imp.g_varchar2_table(191) := '74203D20646F63756D656E742E637265617465456C656D656E744E5328204E532C2022746578742220293B0A20202020202020202020202020202020746578742E73657441747472696275746528202278222C20742E782E746F46697865642820322029';
wwv_flow_imp.g_varchar2_table(192) := '20293B0A20202020202020202020202020202020746578742E73657441747472696275746528202279222C20742E792E746F4669786564282032202920293B0A20202020202020202020202020202020746578742E736574417474726962757465282022';
wwv_flow_imp.g_varchar2_table(193) := '666F6E742D73697A65222C20742E73697A6520293B0A20202020202020202020202020202020746578742E736574417474726962757465282022666F6E742D66616D696C79222C205343524950545F464F4E542E7265706C61636528202F222F672C2022';
wwv_flow_imp.g_varchar2_table(194) := '2722202920293B0A20202020202020202020202020202020746578742E736574417474726962757465282022746578742D616E63686F72222C20226D6964646C652220293B0A20202020202020202020202020202020746578742E736574417474726962';
wwv_flow_imp.g_varchar2_table(195) := '75746528202266696C6C222C20746869732E7061642E70656E436F6C6F7220293B0A20202020202020202020202020202020746578742E74657874436F6E74656E74203D20746869732E74797065643B0A20202020202020202020202020202020737667';
wwv_flow_imp.g_varchar2_table(196) := '2E617070656E6428207465787420293B0A2020202020202020202020207D0A202020202020202020202020636F6E737420786D6C203D206E657720584D4C53657269616C697A657228292E73657269616C697A65546F537472696E67282073766720292C';
wwv_flow_imp.g_varchar2_table(197) := '0A202020202020202020202020202020206279746573203D206E65772054657874456E636F64657228292E656E636F64652820786D6C20293B0A2020202020202020202020206C65742062696E203D2022223B0A20202020202020202020202062797465';
wwv_flow_imp.g_varchar2_table(198) := '732E666F7245616368282062203D3E207B2062696E202B3D20537472696E672E66726F6D43686172436F646528206220293B207D20293B0A20202020202020202020202072657475726E2022646174613A696D6167652F7376672B786D6C3B6261736536';
wwv_flow_imp.g_varchar2_table(199) := '342C22202B2062746F61282062696E20293B0A20202020202020207D0A0A20202020202020206C6F6164282075726C2029207B0A202020202020202020202020746869732E73657454797065642820222220293B0A202020202020202020202020746869';
wwv_flow_imp.g_varchar2_table(200) := '732E62617365203D206E756C6C3B0A202020202020202020202020696620282075726C20262620444154415F55524C2E74657374282075726C20292029207B0A20202020202020202020202020202020636F6E737420696D67203D206E657720496D6167';
wwv_flow_imp.g_varchar2_table(201) := '6528293B0A20202020202020202020202020202020746869732E62617365203D207B2075726C2C20696D67207D3B0A20202020202020202020202020202020696D672E6F6E6C6F6164203D202829203D3E207B206966202820746869732E626173652026';
wwv_flow_imp.g_varchar2_table(202) := '2620746869732E626173652E696D67203D3D3D20696D672029207B20746869732E72657061696E7428205B5D20293B20746869732E75706461746528293B207D207D3B0A20202020202020202020202020202020696D672E737263203D2075726C3B0A20';
wwv_flow_imp.g_varchar2_table(203) := '20202020202020202020207D0A202020202020202020202020746869732E72657061696E7428205B5D20293B0A202020202020202020202020746869732E75706461746528293B0A20202020202020207D0A0A2020202020202020756E646F2829207B0A';
wwv_flow_imp.g_varchar2_table(204) := '202020202020202020202020636F6E7374207374726F6B6573203D20746869732E7061642E746F4461746128292E736C69636528293B0A20202020202020202020202069662028207374726F6B65732E6C656E6774682029207B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(205) := '202020202020207374726F6B65732E706F7028293B0A2020202020202020202020207D20656C7365206966202820746869732E74797065642029207B0A20202020202020202020202020202020746869732E73657454797065642820222220293B0A2020';
wwv_flow_imp.g_varchar2_table(206) := '202020202020202020207D20656C7365207B0A20202020202020202020202020202020746869732E62617365203D206E756C6C3B0A2020202020202020202020207D0A202020202020202020202020746869732E72657061696E7428207374726F6B6573';
wwv_flow_imp.g_varchar2_table(207) := '20293B0A202020202020202020202020746869732E7361766528293B0A20202020202020207D0A0A2020202020202020636C65617228206279557365722029207B0A202020202020202020202020746869732E62617365203D206E756C6C3B0A20202020';
wwv_flow_imp.g_varchar2_table(208) := '2020202020202020746869732E73657454797065642820222220293B0A202020202020202020202020746869732E72657061696E7428205B5D20293B0A202020202020202020202020746869732E7361766528293B0A2020202020202020202020206966';
wwv_flow_imp.g_varchar2_table(209) := '2028206279557365722029207B0A20202020202020202020202020202020617065782E6576656E742E747269676765722820746869732E696E7075742C202274782D7369676E61747572657061642D636C6561722220293B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(210) := '20202020202820746869732E7479706542746E207C7C20746869732E63616E76617320292E666F63757328293B0A2020202020202020202020207D0A20202020202020207D0A0A202020202020202073657444697361626C6564282064697361626C6564';
wwv_flow_imp.g_varchar2_table(211) := '2029207B0A202020202020202020202020746869732E64697361626C6564203D2064697361626C65643B0A202020202020202020202020746869732E696E7075742E64697361626C6564203D2064697361626C65643B0A20202020202020202020202074';
wwv_flow_imp.g_varchar2_table(212) := '6869732E777261702E636C6173734C6973742E746F67676C6528202269732D64697361626C6564222C2064697361626C656420293B0A202020202020202020202020696620282064697361626C65642029207B20746869732E7061642E6F666628293B20';
wwv_flow_imp.g_varchar2_table(213) := '7D20656C7365207B20746869732E7061642E6F6E28293B207D0A2020202020202020202020206966202820746869732E7479706542746E2029207B20746869732E7479706542746E2E64697361626C6564203D2064697361626C65643B207D0A20202020';
wwv_flow_imp.g_varchar2_table(214) := '20202020202020202820746869732E7377617463686573207C7C205B5D20292E636F6E6361742820746869732E73697A6573207C7C205B5D20292E666F7245616368282062203D3E207B20622E64697361626C6564203D2064697361626C65643B207D20';
wwv_flow_imp.g_varchar2_table(215) := '293B0A2020202020202020202020206966202820746869732E74797065496E7075742029207B20746869732E74797065496E7075742E64697361626C6564203D2064697361626C65643B207D0A202020202020202020202020746869732E757064617465';
wwv_flow_imp.g_varchar2_table(216) := '28293B0A20202020202020207D0A202020207D0A0A20202020636F6E73742070616473203D207B7D3B0A202020206E732E7369676E6174757265506164203D207B0A2020202020202020696E697428206974656D4E616D652C206F7074696F6E732C2069';
wwv_flow_imp.g_varchar2_table(217) := '6E6974466E2029207B0A2020202020202020202020206966202820747970656F6620696E6974466E203D3D3D202266756E6374696F6E222029207B206F7074696F6E73203D20696E6974466E28206F7074696F6E732029207C7C206F7074696F6E733B20';
wwv_flow_imp.g_varchar2_table(218) := '7D0A202020202020202020202020636F6E73742070203D206E65772050616428206974656D4E616D652C206F7074696F6E7320293B0A202020202020202020202020706164735B206974656D4E616D65205D203D20703B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(219) := '617065782E6974656D2E63726561746528206974656D4E616D652C207B0A2020202020202020202020202020202067657456616C75653A202829203D3E20702E696E7075742E76616C75652C0A2020202020202020202020202020202073657456616C75';
wwv_flow_imp.g_varchar2_table(220) := '653A2076616C7565203D3E207B0A2020202020202020202020202020202020202020702E696E7075742E76616C7565203D2076616C756520262620444154415F55524C2E74657374282076616C75652029203F2076616C7565203A2022223B0A20202020';
wwv_flow_imp.g_varchar2_table(221) := '20202020202020202020202020202020702E6C6F61642820702E696E7075742E76616C756520293B0A202020202020202020202020202020207D2C0A202020202020202020202020202020206973456D7074793A202829203D3E20702E6973456D707479';
wwv_flow_imp.g_varchar2_table(222) := '28292C0A2020202020202020202020202020202069734368616E6765643A202829203D3E20702E696E7075742E76616C756520213D3D20702E696E7075742E64656661756C7456616C75652C0A20202020202020202020202020202020656E61626C653A';
wwv_flow_imp.g_varchar2_table(223) := '202829203D3E20702E73657444697361626C6564282066616C736520292C0A2020202020202020202020202020202064697361626C653A202829203D3E20702E73657444697361626C656428207472756520292C0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(224) := '20697344697361626C65643A202829203D3E20702E64697361626C65642C0A20202020202020202020202020202020736574466F637573546F3A202829203D3E20242820702E7479706542746E207C7C20702E756E646F42746E207C7C20702E63616E76';
wwv_flow_imp.g_varchar2_table(225) := '617320292C0A2020202020202020202020202020202067657456616C69646974793A202829203D3E207B0A2020202020202020202020202020202020202020636F6E7374206D697373696E67203D202121702E6F2E726571756972656420262620702E69';
wwv_flow_imp.g_varchar2_table(226) := '73456D70747928293B0A202020202020202020202020202020202020202072657475726E207B2076616C69643A20216D697373696E672C2076616C75654D697373696E673A206D697373696E67207D3B0A202020202020202020202020202020207D2C0A';
wwv_flow_imp.g_varchar2_table(227) := '2020202020202020202020202020202067657456616C69646174696F6E4D6573736167653A202829203D3E202820702E6F2E726571756972656420262620702E6973456D7074792829203F2022506C65617365207369676E2E22203A20222220290A2020';
wwv_flow_imp.g_varchar2_table(228) := '202020202020202020207D20293B0A20202020202020207D2C0A20202020202020206765743A206974656D4E616D65203D3E20706164735B206974656D4E616D65205D0A202020207D3B0A7D20292820617065782E6A51756572792C206170657820293B';
wwv_flow_imp.g_varchar2_table(229) := '0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(6148589029671968)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_file_name=>'signature-pad.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A210A202A205369676E6174757265205061642076352E312E34207C2068747470733A2F2F6769746875622E636F6D2F737A696D656B2F7369676E61747572655F7061640A202A20286329203230323620537A796D6F6E204E6F77616B207C2052656C';
wwv_flow_imp.g_varchar2_table(2) := '656173656420756E64657220746865204D4954206C6963656E73650A202A2F0A2866756E6374696F6E28672C66297B696628747970656F66206578706F7274733D3D226F626A656374222626747970656F66206D6F64756C653C227522297B6D6F64756C';
wwv_flow_imp.g_varchar2_table(3) := '652E6578706F7274733D6628297D656C7365206966282266756E6374696F6E223D3D747970656F6620646566696E6520262620646566696E652E616D64297B646566696E6528225369676E6174757265506164222C66297D656C7365207B675B22536967';
wwv_flow_imp.g_varchar2_table(4) := '6E6174757265506164225D3D6628297D7D28747970656F6620676C6F62616C54686973203C20227522203F20676C6F62616C54686973203A20747970656F662073656C66203C20227522203F2073656C66203A20746869732C66756E6374696F6E28297B';
wwv_flow_imp.g_varchar2_table(5) := '766172206578706F7274733D7B7D3B766172205F5F6578706F7274733D6578706F7274733B766172206D6F64756C653D7B6578706F7274737D3B0A76617220793D4F626A6563742E646566696E6550726F70657274793B766172204D3D4F626A6563742E';
wwv_flow_imp.g_varchar2_table(6) := '6765744F776E50726F706572747944657363726970746F723B76617220553D4F626A6563742E6765744F776E50726F70657274794E616D65733B76617220573D4F626A6563742E70726F746F747970652E6861734F776E50726F70657274793B76617220';
wwv_flow_imp.g_varchar2_table(7) := '663D28752C6E2C74293D3E28293D3E7B69662874297468726F7720745B305D3B7472797B72657475726E20752626286E3D7528753D3029292C6E7D63617463682865297B7468726F7720743D5B655D2C657D7D3B766172204C3D28752C6E293D3E7B666F';
wwv_flow_imp.g_varchar2_table(8) := '7228766172207420696E206E297928752C742C7B6765743A6E5B745D2C656E756D657261626C653A21307D297D2C413D28752C6E2C742C65293D3E7B6966286E2626747970656F66206E3D3D226F626A656374227C7C747970656F66206E3D3D2266756E';
wwv_flow_imp.g_varchar2_table(9) := '6374696F6E2229666F72286C65742069206F662055286E292921572E63616C6C28752C6929262669213D3D7426267928752C692C7B6765743A28293D3E6E5B695D2C656E756D657261626C653A2128653D4D286E2C6929297C7C652E656E756D65726162';
wwv_flow_imp.g_varchar2_table(10) := '6C657D293B72657475726E20757D3B76617220473D753D3E412879287B7D2C225F5F65734D6F64756C65222C7B76616C75653A21307D292C75293B76617220622C503D662828293D3E7B2275736520737472696374223B623D636C6173737B783B793B70';
wwv_flow_imp.g_varchar2_table(11) := '726573737572653B74696D653B636F6E7374727563746F72286E2C742C652C69297B69662869734E614E286E297C7C69734E614E287429297468726F77206E6577204572726F722860506F696E7420697320696E76616C69643A2028247B6E7D2C20247B';
wwv_flow_imp.g_varchar2_table(12) := '747D2960293B746869732E783D2B6E2C746869732E793D2B742C746869732E70726573737572653D657C7C302C746869732E74696D653D697C7C446174652E6E6F7728297D64697374616E6365546F286E297B72657475726E204D6174682E7371727428';
wwv_flow_imp.g_varchar2_table(13) := '4D6174682E706F7728746869732E782D6E2E782C32292B4D6174682E706F7728746869732E792D6E2E792C3229297D657175616C73286E297B72657475726E20746869732E783D3D3D6E2E782626746869732E793D3D3D6E2E792626746869732E707265';
wwv_flow_imp.g_varchar2_table(14) := '73737572653D3D3D6E2E70726573737572652626746869732E74696D653D3D3D6E2E74696D657D76656C6F6369747946726F6D286E297B72657475726E20746869732E74696D65213D3D6E2E74696D653F746869732E64697374616E6365546F286E292F';
wwv_flow_imp.g_varchar2_table(15) := '28746869732E74696D652D6E2E74696D65293A307D7D7D293B76617220782C533D662828293D3E7B2275736520737472696374223B5028293B783D636C61737320757B636F6E7374727563746F72286E2C742C652C692C6F2C72297B746869732E737461';
wwv_flow_imp.g_varchar2_table(16) := '7274506F696E743D6E3B746869732E636F6E74726F6C323D743B746869732E636F6E74726F6C313D653B746869732E656E64506F696E743D693B746869732E737461727457696474683D6F3B746869732E656E6457696474683D727D7374617274506F69';
wwv_flow_imp.g_varchar2_table(17) := '6E743B636F6E74726F6C323B636F6E74726F6C313B656E64506F696E743B737461727457696474683B656E6457696474683B7374617469632066726F6D506F696E7473286E2C74297B6C657420653D746869732E63616C63756C617465436F6E74726F6C';
wwv_flow_imp.g_varchar2_table(18) := '506F696E7473286E5B305D2C6E5B315D2C6E5B325D292E63322C693D746869732E63616C63756C617465436F6E74726F6C506F696E7473286E5B315D2C6E5B325D2C6E5B335D292E63313B72657475726E206E65772075286E5B315D2C652C692C6E5B32';
wwv_flow_imp.g_varchar2_table(19) := '5D2C742E73746172742C742E656E64297D7374617469632063616C63756C617465436F6E74726F6C506F696E7473286E2C742C65297B6C657420693D6E2E782D742E782C6F3D6E2E792D742E792C723D742E782D652E782C6C3D742E792D652E792C613D';
wwv_flow_imp.g_varchar2_table(20) := '7B783A286E2E782B742E78292F322C793A286E2E792B742E79292F327D2C633D7B783A28742E782B652E78292F322C793A28742E792B652E79292F327D2C683D4D6174682E7371727428692A692B6F2A6F292C733D4D6174682E7371727428722A722B6C';
wwv_flow_imp.g_varchar2_table(21) := '2A6C292C703D612E782D632E782C763D612E792D632E792C643D682B733D3D303F303A732F28682B73292C5F3D7B783A632E782B702A642C793A632E792B762A647D2C6D3D742E782D5F2E782C673D742E792D5F2E793B72657475726E7B63313A6E6577';
wwv_flow_imp.g_varchar2_table(22) := '206228612E782B6D2C612E792B67292C63323A6E6577206228632E782B6D2C632E792B67297D7D6C656E67746828297B6C657420743D302C652C693B666F72286C6574206F3D303B6F3C3D31303B6F2B3D31297B6C657420723D6F2F31302C6C3D746869';
wwv_flow_imp.g_varchar2_table(23) := '732E706F696E7428722C746869732E7374617274506F696E742E782C746869732E636F6E74726F6C312E782C746869732E636F6E74726F6C322E782C746869732E656E64506F696E742E78292C613D746869732E706F696E7428722C746869732E737461';
wwv_flow_imp.g_varchar2_table(24) := '7274506F696E742E792C746869732E636F6E74726F6C312E792C746869732E636F6E74726F6C322E792C746869732E656E64506F696E742E79293B6966286F3E30297B6C657420633D6C2D652C683D612D693B742B3D4D6174682E7371727428632A632B';
wwv_flow_imp.g_varchar2_table(25) := '682A68297D653D6C2C693D617D72657475726E20747D706F696E74286E2C742C652C692C6F297B72657475726E20742A28312D6E292A28312D6E292A28312D6E292B332A652A28312D6E292A28312D6E292A6E2B332A692A28312D6E292A6E2A6E2B6F2A';
wwv_flow_imp.g_varchar2_table(26) := '6E2A6E2A6E7D7D7D293B76617220772C433D662828293D3E7B2275736520737472696374223B773D636C6173737B5F65743B636F6E7374727563746F7228297B7472797B746869732E5F65743D6E6577204576656E745461726765747D63617463687B74';
wwv_flow_imp.g_varchar2_table(27) := '6869732E5F65743D646F63756D656E747D7D6164644576656E744C697374656E6572286E2C742C65297B746869732E5F65742E6164644576656E744C697374656E6572286E2C742C65297D64697370617463684576656E74286E297B72657475726E2074';
wwv_flow_imp.g_varchar2_table(28) := '6869732E5F65742E64697370617463684576656E74286E297D72656D6F76654576656E744C697374656E6572286E2C742C65297B746869732E5F65742E72656D6F76654576656E744C697374656E6572286E2C742C65297D7D7D293B66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(29) := '204F28752C6E3D323530297B6C657420743D302C653D6E756C6C2C692C6F2C722C6C3D28293D3E7B743D446174652E6E6F7728292C653D6E756C6C2C693D752E6170706C79286F2C72292C657C7C286F3D6E756C6C2C723D5B5D297D3B72657475726E20';
wwv_flow_imp.g_varchar2_table(30) := '66756E6374696F6E282E2E2E63297B6C657420683D446174652E6E6F7728292C733D6E2D28682D74293B72657475726E206F3D746869732C723D632C733C3D307C7C733E6E3F2865262628636C65617254696D656F75742865292C653D6E756C6C292C74';
wwv_flow_imp.g_varchar2_table(31) := '3D682C693D752E6170706C79286F2C72292C657C7C286F3D6E756C6C2C723D5B5D29293A657C7C28653D77696E646F772E73657454696D656F7574286C2C7329292C697D7D766172206B3D662828293D3E7B2275736520737472696374227D293B766172';
wwv_flow_imp.g_varchar2_table(32) := '20543D7B7D3B4C28542C7B64656661756C743A28293D3E457D293B76617220452C443D662828293D3E7B2275736520737472696374223B5328293B5028293B4328293B6B28293B5028293B453D636C617373207520657874656E647320777B636F6E7374';
wwv_flow_imp.g_varchar2_table(33) := '727563746F7228742C653D7B7D297B737570657228293B746869732E63616E7661733D743B746869732E76656C6F6369747946696C7465725765696768743D652E76656C6F6369747946696C7465725765696768747C7C2E372C746869732E6D696E5769';
wwv_flow_imp.g_varchar2_table(34) := '6474683D652E6D696E57696474687C7C2E352C746869732E6D617857696474683D652E6D617857696474687C7C322E352C746869732E7468726F74746C653D652E7468726F74746C653F3F31362C746869732E6D696E44697374616E63653D652E6D696E';
wwv_flow_imp.g_varchar2_table(35) := '44697374616E63653F3F352C746869732E646F7453697A653D652E646F7453697A657C7C302C746869732E70656E436F6C6F723D652E70656E436F6C6F727C7C22626C61636B222C746869732E6261636B67726F756E64436F6C6F723D652E6261636B67';
wwv_flow_imp.g_varchar2_table(36) := '726F756E64436F6C6F727C7C227267626128302C302C302C3029222C746869732E636F6D706F736974654F7065726174696F6E3D652E636F6D706F736974654F7065726174696F6E7C7C22736F757263652D6F766572222C746869732E63616E76617343';
wwv_flow_imp.g_varchar2_table(37) := '6F6E746578744F7074696F6E733D652E63616E766173436F6E746578744F7074696F6E733F3F7B7D2C746869732E5F7374726F6B654D6F76655570646174653D746869732E7468726F74746C653F4F28752E70726F746F747970652E5F7374726F6B6555';
wwv_flow_imp.g_varchar2_table(38) := '70646174652C746869732E7468726F74746C65293A752E70726F746F747970652E5F7374726F6B655570646174652C746869732E5F68616E646C654D6F757365446F776E3D746869732E5F68616E646C654D6F757365446F776E2E62696E642874686973';
wwv_flow_imp.g_varchar2_table(39) := '292C746869732E5F68616E646C654D6F7573654D6F76653D746869732E5F68616E646C654D6F7573654D6F76652E62696E642874686973292C746869732E5F68616E646C654D6F75736555703D746869732E5F68616E646C654D6F75736555702E62696E';
wwv_flow_imp.g_varchar2_table(40) := '642874686973292C746869732E5F68616E646C65546F75636853746172743D746869732E5F68616E646C65546F75636853746172742E62696E642874686973292C746869732E5F68616E646C65546F7563684D6F76653D746869732E5F68616E646C6554';
wwv_flow_imp.g_varchar2_table(41) := '6F7563684D6F76652E62696E642874686973292C746869732E5F68616E646C65546F756368456E643D746869732E5F68616E646C65546F756368456E642E62696E642874686973292C746869732E5F68616E646C65506F696E746572446F776E3D746869';
wwv_flow_imp.g_varchar2_table(42) := '732E5F68616E646C65506F696E746572446F776E2E62696E642874686973292C746869732E5F68616E646C65506F696E7465724D6F76653D746869732E5F68616E646C65506F696E7465724D6F76652E62696E642874686973292C746869732E5F68616E';
wwv_flow_imp.g_varchar2_table(43) := '646C65506F696E74657255703D746869732E5F68616E646C65506F696E74657255702E62696E642874686973292C746869732E5F68616E646C65506F696E74657243616E63656C3D746869732E5F68616E646C65506F696E74657243616E63656C2E6269';
wwv_flow_imp.g_varchar2_table(44) := '6E642874686973292C746869732E5F68616E646C65546F75636843616E63656C3D746869732E5F68616E646C65546F75636843616E63656C2E62696E642874686973292C746869732E5F6374783D742E676574436F6E7465787428223264222C74686973';
wwv_flow_imp.g_varchar2_table(45) := '2E63616E766173436F6E746578744F7074696F6E73292C746869732E636C65617228292C746869732E6F6E28297D63616E7661733B646F7453697A653B6D696E57696474683B6D617857696474683B70656E436F6C6F723B6D696E44697374616E63653B';
wwv_flow_imp.g_varchar2_table(46) := '76656C6F6369747946696C7465725765696768743B636F6D706F736974654F7065726174696F6E3B6261636B67726F756E64436F6C6F723B7468726F74746C653B63616E766173436F6E746578744F7074696F6E733B5F6374783B5F64726177696E6753';
wwv_flow_imp.g_varchar2_table(47) := '74726F6B653D21313B5F6973456D7074793D21303B5F6461746155726C3B5F6461746155726C4F7074696F6E733B5F6C617374506F696E74733D5B5D3B5F646174613D5B5D3B5F6C61737456656C6F636974793D303B5F6C61737457696474683D303B5F';
wwv_flow_imp.g_varchar2_table(48) := '7374726F6B654D6F76655570646174653B5F7374726F6B65506F696E74657249643B636C65617228297B6C65747B5F6374783A742C63616E7661733A657D3D746869733B742E66696C6C5374796C653D746869732E6261636B67726F756E64436F6C6F72';
wwv_flow_imp.g_varchar2_table(49) := '2C742E636C6561725265637428302C302C652E77696474682C652E686569676874292C742E66696C6C5265637428302C302C652E77696474682C652E686569676874292C746869732E5F646174613D5B5D2C746869732E5F726573657428746869732E5F';
wwv_flow_imp.g_varchar2_table(50) := '676574506F696E7447726F75704F7074696F6E732829292C746869732E5F6973456D7074793D21302C746869732E5F6461746155726C3D766F696420302C746869732E5F6461746155726C4F7074696F6E733D766F696420302C746869732E5F7374726F';
wwv_flow_imp.g_varchar2_table(51) := '6B65506F696E74657249643D766F696420307D72656472617728297B6C657420743D746869732E5F646174612C653D746869732E5F6461746155726C2C693D746869732E5F6461746155726C4F7074696F6E733B746869732E636C65617228292C652626';
wwv_flow_imp.g_varchar2_table(52) := '746869732E66726F6D4461746155524C28652C69292C746869732E66726F6D4461746128742C7B636C6561723A21317D297D66726F6D4461746155524C28742C653D7B7D297B72657475726E206E65772050726F6D6973652828692C6F293D3E7B6C6574';
wwv_flow_imp.g_varchar2_table(53) := '20723D6E657720496D6167652C6C3D652E726174696F7C7C77696E646F772E646576696365506978656C526174696F7C7C312C613D652E77696474687C7C746869732E63616E7661732E77696474682F6C2C633D652E6865696768747C7C746869732E63';
wwv_flow_imp.g_varchar2_table(54) := '616E7661732E6865696768742F6C2C683D652E784F66667365747C7C302C733D652E794F66667365747C7C303B746869732E5F726573657428746869732E5F676574506F696E7447726F75704F7074696F6E732829292C722E6F6E6C6F61643D28293D3E';
wwv_flow_imp.g_varchar2_table(55) := '7B746869732E5F6374782E64726177496D61676528722C682C732C612C63292C6928297D2C722E6F6E6572726F723D703D3E7B6F2870297D2C722E63726F73734F726967696E3D22616E6F6E796D6F7573222C722E7372633D742C746869732E5F697345';
wwv_flow_imp.g_varchar2_table(56) := '6D7074793D21312C746869732E5F6461746155726C3D742C746869732E5F6461746155726C4F7074696F6E733D7B2E2E2E657D7D297D746F4461746155524C28743D22696D6167652F706E67222C65297B72657475726E20743D3D3D22696D6167652F73';
wwv_flow_imp.g_varchar2_table(57) := '76672B786D6C223F28747970656F662065213D226F626A65637422262628653D766F69642030292C60646174613A696D6167652F7376672B786D6C3B6261736536342C247B62746F6128746869732E746F535647286529297D60293A28747970656F6620';
wwv_flow_imp.g_varchar2_table(58) := '65213D226E756D62657222262628653D766F69642030292C746869732E63616E7661732E746F4461746155524C28742C6529297D6F6E28297B746869732E63616E7661732E7374796C652E746F756368416374696F6E3D226E6F6E65222C746869732E63';
wwv_flow_imp.g_varchar2_table(59) := '616E7661732E7374796C652E6D73546F756368416374696F6E3D226E6F6E65222C746869732E63616E7661732E7374796C652E7573657253656C6563743D226E6F6E65222C746869732E63616E7661732E7374796C652E7765626B69745573657253656C';
wwv_flow_imp.g_varchar2_table(60) := '6563743D226E6F6E65223B6C657420743D2F4D6163696E746F73682F2E74657374286E6176696761746F722E757365724167656E74292626226F6E746F756368737461727422696E20646F63756D656E743B77696E646F772E506F696E7465724576656E';
wwv_flow_imp.g_varchar2_table(61) := '74262621743F746869732E5F68616E646C65506F696E7465724576656E747328293A28746869732E5F68616E646C654D6F7573654576656E747328292C226F6E746F756368737461727422696E2077696E646F772626746869732E5F68616E646C65546F';
wwv_flow_imp.g_varchar2_table(62) := '7563684576656E74732829297D6F666628297B746869732E63616E7661732E7374796C652E746F756368416374696F6E3D226175746F222C746869732E63616E7661732E7374796C652E6D73546F756368416374696F6E3D226175746F222C746869732E';
wwv_flow_imp.g_varchar2_table(63) := '63616E7661732E7374796C652E7573657253656C6563743D226175746F222C746869732E63616E7661732E7374796C652E7765626B69745573657253656C6563743D226175746F222C746869732E63616E7661732E72656D6F76654576656E744C697374';
wwv_flow_imp.g_varchar2_table(64) := '656E65722822706F696E746572646F776E222C746869732E5F68616E646C65506F696E746572446F776E292C746869732E63616E7661732E72656D6F76654576656E744C697374656E657228226D6F757365646F776E222C746869732E5F68616E646C65';
wwv_flow_imp.g_varchar2_table(65) := '4D6F757365446F776E292C746869732E63616E7661732E72656D6F76654576656E744C697374656E65722822746F7563687374617274222C746869732E5F68616E646C65546F7563685374617274292C746869732E5F72656D6F76654D6F766555704576';
wwv_flow_imp.g_varchar2_table(66) := '656E744C697374656E65727328297D5F6765744C697374656E657246756E6374696F6E7328297B6C657420743D77696E646F772E646F63756D656E743D3D3D746869732E63616E7661732E6F776E6572446F63756D656E743F77696E646F773A74686973';
wwv_flow_imp.g_varchar2_table(67) := '2E63616E7661732E6F776E6572446F63756D656E742E64656661756C74566965773F3F746869732E63616E7661732E6F776E6572446F63756D656E743B72657475726E7B6164644576656E744C697374656E65723A742E6164644576656E744C69737465';
wwv_flow_imp.g_varchar2_table(68) := '6E65722E62696E642874292C72656D6F76654576656E744C697374656E65723A742E72656D6F76654576656E744C697374656E65722E62696E642874297D7D5F72656D6F76654D6F766555704576656E744C697374656E65727328297B6C65747B72656D';
wwv_flow_imp.g_varchar2_table(69) := '6F76654576656E744C697374656E65723A747D3D746869732E5F6765744C697374656E657246756E6374696F6E7328293B742822706F696E7465726D6F7665222C746869732E5F68616E646C65506F696E7465724D6F7665292C742822706F696E746572';
wwv_flow_imp.g_varchar2_table(70) := '7570222C746869732E5F68616E646C65506F696E7465725570292C742822706F696E74657263616E63656C222C746869732E5F68616E646C65506F696E74657243616E63656C292C7428226D6F7573656D6F7665222C746869732E5F68616E646C654D6F';
wwv_flow_imp.g_varchar2_table(71) := '7573654D6F7665292C7428226D6F7573657570222C746869732E5F68616E646C654D6F7573655570292C742822746F7563686D6F7665222C746869732E5F68616E646C65546F7563684D6F7665292C742822746F756368656E64222C746869732E5F6861';
wwv_flow_imp.g_varchar2_table(72) := '6E646C65546F756368456E64292C742822746F75636863616E63656C222C746869732E5F68616E646C65546F75636843616E63656C297D6973456D70747928297B72657475726E20746869732E5F6973456D7074797D66726F6D4461746128742C7B636C';
wwv_flow_imp.g_varchar2_table(73) := '6561723A653D21307D3D7B7D297B652626746869732E636C65617228292C746869732E5F66726F6D4461746128742C746869732E5F6472617743757276652E62696E642874686973292C746869732E5F64726177446F742E62696E642874686973292C74';
wwv_flow_imp.g_varchar2_table(74) := '6869732E5F647261774C696E652E62696E64287468697329292C746869732E5F646174613D746869732E5F646174612E636F6E6361742874297D746F4461746128297B72657475726E20746869732E5F646174617D5F69734C656674427574746F6E5072';
wwv_flow_imp.g_varchar2_table(75) := '657373656428742C65297B72657475726E20653F742E627574746F6E733D3D3D313A28742E627574746F6E732631293D3D3D317D5F706F696E7465724576656E74546F5369676E61747572654576656E742874297B72657475726E7B6576656E743A742C';
wwv_flow_imp.g_varchar2_table(76) := '747970653A742E747970652C783A742E636C69656E74582C793A742E636C69656E74592C70726573737572653A22707265737375726522696E20743F742E70726573737572653A307D7D5F746F7563684576656E74546F5369676E61747572654576656E';
wwv_flow_imp.g_varchar2_table(77) := '742874297B6C657420653D742E6368616E676564546F75636865735B305D3B72657475726E7B6576656E743A742C747970653A742E747970652C783A652E636C69656E74582C793A652E636C69656E74592C70726573737572653A652E666F7263657D7D';
wwv_flow_imp.g_varchar2_table(78) := '5F68616E646C654D6F757365446F776E2874297B21746869732E5F69734C656674427574746F6E5072657373656428742C2130297C7C746869732E5F64726177696E675374726F6B657C7C746869732E5F7374726F6B65426567696E28746869732E5F70';
wwv_flow_imp.g_varchar2_table(79) := '6F696E7465724576656E74546F5369676E61747572654576656E74287429297D5F68616E646C654D6F7573654D6F76652874297B69662821746869732E5F69734C656674427574746F6E5072657373656428742C2130297C7C21746869732E5F64726177';
wwv_flow_imp.g_varchar2_table(80) := '696E675374726F6B65297B746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E742874292C2131293B72657475726E7D746869732E5F7374726F6B654D6F76655570646174652874';
wwv_flow_imp.g_varchar2_table(81) := '6869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429297D5F68616E646C654D6F75736555702874297B746869732E5F69734C656674427574746F6E507265737365642874297C7C746869732E5F7374726F6B65456E';
wwv_flow_imp.g_varchar2_table(82) := '6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429297D5F68616E646C65546F75636853746172742874297B742E746172676574546F75636865732E6C656E677468213D3D317C7C746869732E5F64726177';
wwv_flow_imp.g_varchar2_table(83) := '696E675374726F6B657C7C28742E63616E63656C61626C652626742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65426567696E28746869732E5F746F7563684576656E74546F5369676E61747572654576656E742874292929';
wwv_flow_imp.g_varchar2_table(84) := '7D5F68616E646C65546F7563684D6F76652874297B696628742E746172676574546F75636865732E6C656E6774683D3D3D31297B696628742E63616E63656C61626C652626742E70726576656E7444656661756C7428292C21746869732E5F6472617769';
wwv_flow_imp.g_varchar2_table(85) := '6E675374726F6B65297B746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F5369676E61747572654576656E742874292C2131293B72657475726E7D746869732E5F7374726F6B654D6F76655570646174652874686973';
wwv_flow_imp.g_varchar2_table(86) := '2E5F746F7563684576656E74546F5369676E61747572654576656E74287429297D7D5F68616E646C65546F756368456E642874297B742E746172676574546F75636865732E6C656E6774683D3D3D30262628742E63616E63656C61626C652626742E7072';
wwv_flow_imp.g_varchar2_table(87) := '6576656E7444656661756C7428292C746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F5369676E61747572654576656E7428742929297D5F68616E646C65506F696E74657243616E63656C2874297B746869732E5F61';
wwv_flow_imp.g_varchar2_table(88) := '6C6C6F77506F696E7465724964287429262628742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E742874292C213129297D5F6861';
wwv_flow_imp.g_varchar2_table(89) := '6E646C65546F75636843616E63656C2874297B742E63616E63656C61626C652626742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F5369676E61747572654576656E74';
wwv_flow_imp.g_varchar2_table(90) := '2874292C2131297D5F676574506F696E74657249642874297B72657475726E20742E70657273697374656E7444657669636549647C7C742E706F696E74657249647D5F616C6C6F77506F696E746572496428742C653D2131297B72657475726E20747970';
wwv_flow_imp.g_varchar2_table(91) := '656F6620746869732E5F7374726F6B65506F696E74657249643E2275223F653A746869732E5F676574506F696E74657249642874293D3D3D746869732E5F7374726F6B65506F696E74657249647D5F68616E646C65506F696E746572446F776E2874297B';
wwv_flow_imp.g_varchar2_table(92) := '746869732E5F64726177696E675374726F6B657C7C21746869732E5F69734C656674427574746F6E507265737365642874297C7C21746869732E5F616C6C6F77506F696E746572496428742C2130297C7C28746869732E5F7374726F6B65506F696E7465';
wwv_flow_imp.g_varchar2_table(93) := '7249643D746869732E5F676574506F696E74657249642874292C742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65426567696E28746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429';
wwv_flow_imp.g_varchar2_table(94) := '29297D5F68616E646C65506F696E7465724D6F76652874297B696628746869732E5F616C6C6F77506F696E7465724964287429297B69662821746869732E5F69734C656674427574746F6E5072657373656428742C2130297C7C21746869732E5F647261';
wwv_flow_imp.g_varchar2_table(95) := '77696E675374726F6B65297B746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E742874292C2131293B72657475726E7D742E70726576656E7444656661756C7428292C74686973';
wwv_flow_imp.g_varchar2_table(96) := '2E5F7374726F6B654D6F766555706461746528746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429297D7D5F68616E646C65506F696E74657255702874297B746869732E5F69734C656674427574746F6E507265';
wwv_flow_imp.g_varchar2_table(97) := '737365642874297C7C21746869732E5F616C6C6F77506F696E74657249642874297C7C28742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E6174757265';
wwv_flow_imp.g_varchar2_table(98) := '4576656E7428742929297D5F676574506F696E7447726F75704F7074696F6E732874297B72657475726E7B70656E436F6C6F723A7426262270656E436F6C6F7222696E20743F742E70656E436F6C6F723A746869732E70656E436F6C6F722C646F745369';
wwv_flow_imp.g_varchar2_table(99) := '7A653A74262622646F7453697A6522696E20743F742E646F7453697A653A746869732E646F7453697A652C6D696E57696474683A742626226D696E576964746822696E20743F742E6D696E57696474683A746869732E6D696E57696474682C6D61785769';
wwv_flow_imp.g_varchar2_table(100) := '6474683A742626226D6178576964746822696E20743F742E6D617857696474683A746869732E6D617857696474682C76656C6F6369747946696C7465725765696768743A7426262276656C6F6369747946696C74657257656967687422696E20743F742E';
wwv_flow_imp.g_varchar2_table(101) := '76656C6F6369747946696C7465725765696768743A746869732E76656C6F6369747946696C7465725765696768742C636F6D706F736974654F7065726174696F6E3A74262622636F6D706F736974654F7065726174696F6E22696E20743F742E636F6D70';
wwv_flow_imp.g_varchar2_table(102) := '6F736974654F7065726174696F6E3A746869732E636F6D706F736974654F7065726174696F6E7D7D5F7374726F6B65426567696E2874297B69662821746869732E64697370617463684576656E74286E657720437573746F6D4576656E74282262656769';
wwv_flow_imp.g_varchar2_table(103) := '6E5374726F6B65222C7B64657461696C3A742C63616E63656C61626C653A21307D29292972657475726E3B6C65747B6164644576656E744C697374656E65723A697D3D746869732E5F6765744C697374656E657246756E6374696F6E7328293B73776974';
wwv_flow_imp.g_varchar2_table(104) := '636828742E6576656E742E74797065297B63617365226D6F757365646F776E223A6928226D6F7573656D6F7665222C746869732E5F68616E646C654D6F7573654D6F76652C7B706173736976653A21317D292C6928226D6F7573657570222C746869732E';
wwv_flow_imp.g_varchar2_table(105) := '5F68616E646C654D6F75736555702C7B706173736976653A21317D293B627265616B3B6361736522746F7563687374617274223A692822746F7563686D6F7665222C746869732E5F68616E646C65546F7563684D6F76652C7B706173736976653A21317D';
wwv_flow_imp.g_varchar2_table(106) := '292C692822746F756368656E64222C746869732E5F68616E646C65546F756368456E642C7B706173736976653A21317D292C692822746F75636863616E63656C222C746869732E5F68616E646C65546F75636843616E63656C2C7B706173736976653A21';
wwv_flow_imp.g_varchar2_table(107) := '317D293B627265616B3B6361736522706F696E746572646F776E223A692822706F696E7465726D6F7665222C746869732E5F68616E646C65506F696E7465724D6F76652C7B706173736976653A21317D292C692822706F696E7465727570222C74686973';
wwv_flow_imp.g_varchar2_table(108) := '2E5F68616E646C65506F696E74657255702C7B706173736976653A21317D292C692822706F696E74657263616E63656C222C746869732E5F68616E646C65506F696E74657243616E63656C2C7B706173736976653A21317D293B627265616B3B64656661';
wwv_flow_imp.g_varchar2_table(109) := '756C743A7D746869732E5F64726177696E675374726F6B653D21303B6C6574206F3D746869732E5F676574506F696E7447726F75704F7074696F6E7328292C723D7B2E2E2E6F2C706F696E74733A5B5D7D3B746869732E5F646174612E70757368287229';
wwv_flow_imp.g_varchar2_table(110) := '2C746869732E5F7265736574286F292C746869732E5F7374726F6B655570646174652874297D5F7374726F6B655570646174652874297B69662821746869732E5F64726177696E675374726F6B652972657475726E3B696628746869732E5F646174612E';
wwv_flow_imp.g_varchar2_table(111) := '6C656E6774683D3D3D30297B746869732E5F7374726F6B65426567696E2874293B72657475726E7D746869732E64697370617463684576656E74286E657720437573746F6D4576656E7428226265666F72655570646174655374726F6B65222C7B646574';
wwv_flow_imp.g_varchar2_table(112) := '61696C3A747D29293B6C657420653D746869732E5F637265617465506F696E7428742E782C742E792C742E7072657373757265292C693D746869732E5F646174615B746869732E5F646174612E6C656E6774682D315D2C6F3D692E706F696E74732C723D';
wwv_flow_imp.g_varchar2_table(113) := '6F2E6C656E6774683E3026266F5B6F2E6C656E6774682D315D2C6C3D723F652E64697374616E6365546F2872293C3D746869732E6D696E44697374616E63653A21312C613D746869732E5F676574506F696E7447726F75704F7074696F6E732869293B69';
wwv_flow_imp.g_varchar2_table(114) := '662821727C7C21287226266C29297B6C657420633D746869732E5F616464506F696E7428652C61293B723F632626746869732E5F64726177437572766528632C61293A746869732E5F64726177446F7428652C61292C6F2E70757368287B74696D653A65';
wwv_flow_imp.g_varchar2_table(115) := '2E74696D652C783A652E782C793A652E792C70726573737572653A652E70726573737572657D297D746869732E64697370617463684576656E74286E657720437573746F6D4576656E74282261667465725570646174655374726F6B65222C7B64657461';
wwv_flow_imp.g_varchar2_table(116) := '696C3A747D29297D5F7374726F6B65456E6428742C653D2130297B746869732E5F72656D6F76654D6F766555704576656E744C697374656E65727328292C746869732E5F64726177696E675374726F6B65262628652626746869732E5F7374726F6B6555';
wwv_flow_imp.g_varchar2_table(117) := '70646174652874292C746869732E5F64726177696E675374726F6B653D21312C746869732E5F7374726F6B65506F696E74657249643D766F696420302C746869732E64697370617463684576656E74286E657720437573746F6D4576656E742822656E64';
wwv_flow_imp.g_varchar2_table(118) := '5374726F6B65222C7B64657461696C3A747D2929297D5F68616E646C65506F696E7465724576656E747328297B746869732E5F64726177696E675374726F6B653D21312C746869732E63616E7661732E6164644576656E744C697374656E65722822706F';
wwv_flow_imp.g_varchar2_table(119) := '696E746572646F776E222C746869732E5F68616E646C65506F696E746572446F776E2C7B706173736976653A21317D297D5F68616E646C654D6F7573654576656E747328297B746869732E5F64726177696E675374726F6B653D21312C746869732E6361';
wwv_flow_imp.g_varchar2_table(120) := '6E7661732E6164644576656E744C697374656E657228226D6F757365646F776E222C746869732E5F68616E646C654D6F757365446F776E2C7B706173736976653A21317D297D5F68616E646C65546F7563684576656E747328297B746869732E63616E76';
wwv_flow_imp.g_varchar2_table(121) := '61732E6164644576656E744C697374656E65722822746F7563687374617274222C746869732E5F68616E646C65546F75636853746172742C7B706173736976653A21317D297D5F72657365742874297B746869732E5F6C617374506F696E74733D5B5D2C';
wwv_flow_imp.g_varchar2_table(122) := '746869732E5F6C61737456656C6F636974793D302C746869732E5F6C61737457696474683D28742E6D696E57696474682B742E6D61785769647468292F322C746869732E5F6374782E66696C6C5374796C653D742E70656E436F6C6F722C746869732E5F';
wwv_flow_imp.g_varchar2_table(123) := '6374782E676C6F62616C436F6D706F736974654F7065726174696F6E3D742E636F6D706F736974654F7065726174696F6E7D5F637265617465506F696E7428742C652C69297B6C6574206F3D746869732E63616E7661732E676574426F756E64696E6743';
wwv_flow_imp.g_varchar2_table(124) := '6C69656E745265637428293B72657475726E206E6577206228742D6F2E6C6566742C652D6F2E746F702C692C6E6577204461746528292E67657454696D652829297D5F616464506F696E7428742C65297B6C65747B5F6C617374506F696E74733A697D3D';
wwv_flow_imp.g_varchar2_table(125) := '746869733B696628692E707573682874292C692E6C656E6774683E32297B692E6C656E6774683D3D3D332626692E756E736869667428695B305D293B6C6574206F3D746869732E5F63616C63756C617465437572766557696474687328695B315D2C695B';
wwv_flow_imp.g_varchar2_table(126) := '325D2C65292C723D782E66726F6D506F696E747328692C6F293B72657475726E20692E736869667428292C727D72657475726E206E756C6C7D5F63616C63756C617465437572766557696474687328742C652C69297B6C6574206F3D692E76656C6F6369';
wwv_flow_imp.g_varchar2_table(127) := '747946696C7465725765696768742A652E76656C6F6369747946726F6D2874292B28312D692E76656C6F6369747946696C746572576569676874292A746869732E5F6C61737456656C6F636974792C723D746869732E5F7374726F6B655769647468286F';
wwv_flow_imp.g_varchar2_table(128) := '2C69292C6C3D7B656E643A722C73746172743A746869732E5F6C61737457696474687D3B72657475726E20746869732E5F6C61737456656C6F636974793D6F2C746869732E5F6C61737457696474683D722C6C7D5F7374726F6B65576964746828742C65';
wwv_flow_imp.g_varchar2_table(129) := '297B72657475726E204D6174682E6D617828652E6D617857696474682F28742B31292C652E6D696E5769647468297D5F6472617743757276655365676D656E7428742C652C69297B6C6574206F3D746869732E5F6374783B6F2E6D6F7665546F28742C65';
wwv_flow_imp.g_varchar2_table(130) := '292C6F2E61726328742C652C692C302C322A4D6174682E50492C2131292C746869732E5F6973456D7074793D21317D5F64726177437572766528742C65297B6C657420693D746869732E5F6374782C6F3D742E656E6457696474682D742E737461727457';
wwv_flow_imp.g_varchar2_table(131) := '696474682C723D4D6174682E6365696C28742E6C656E6774682829292A323B692E626567696E5061746828292C692E66696C6C5374796C653D652E70656E436F6C6F723B666F72286C6574206C3D303B6C3C723B6C2B3D31297B6C657420613D6C2F722C';
wwv_flow_imp.g_varchar2_table(132) := '633D612A612C683D632A612C733D312D612C703D732A732C763D702A732C643D762A742E7374617274506F696E742E783B642B3D332A702A612A742E636F6E74726F6C312E782C642B3D332A732A632A742E636F6E74726F6C322E782C642B3D682A742E';
wwv_flow_imp.g_varchar2_table(133) := '656E64506F696E742E783B6C6574205F3D762A742E7374617274506F696E742E793B5F2B3D332A702A612A742E636F6E74726F6C312E792C5F2B3D332A732A632A742E636F6E74726F6C322E792C5F2B3D682A742E656E64506F696E742E793B6C657420';
wwv_flow_imp.g_varchar2_table(134) := '6D3D4D6174682E6D696E28742E737461727457696474682B682A6F2C652E6D61785769647468293B746869732E5F6472617743757276655365676D656E7428642C5F2C6D297D692E636C6F73655061746828292C692E66696C6C28297D5F676574446F74';
wwv_flow_imp.g_varchar2_table(135) := '53697A652874297B72657475726E20742E646F7453697A653E303F742E646F7453697A653A28742E6D696E57696474682B742E6D61785769647468292F327D5F64726177446F7428742C65297B6C657420693D746869732E5F6374782C6F3D746869732E';
wwv_flow_imp.g_varchar2_table(136) := '5F676574446F7453697A652865293B692E626567696E5061746828292C746869732E5F6472617743757276655365676D656E7428742E782C742E792C6F292C692E636C6F73655061746828292C692E66696C6C5374796C653D652E70656E436F6C6F722C';
wwv_flow_imp.g_varchar2_table(137) := '692E66696C6C28297D5F647261774C696E6528742C652C69297B6C6574206F3D746869732E5F6374783B6F2E7361766528292C6F2E626567696E5061746828292C6F2E6D6F7665546F28742E782C742E79292C6F2E6C696E65546F28652E782C652E7929';
wwv_flow_imp.g_varchar2_table(138) := '2C6F2E6C696E6557696474683D746869732E5F676574446F7453697A652869292A322C6F2E6C696E654361703D22726F756E64222C6F2E7374726F6B655374796C653D692E70656E436F6C6F722C6F2E7374726F6B6528292C6F2E726573746F72652829';
wwv_flow_imp.g_varchar2_table(139) := '2C746869732E5F6973456D7074793D21317D5F66726F6D4461746128742C652C692C6F297B666F72286C65742072206F662074297B6C65747B706F696E74733A6C7D3D722C613D746869732E5F676574506F696E7447726F75704F7074696F6E73287229';
wwv_flow_imp.g_varchar2_table(140) := '3B6966286C2E6C656E6774683E3229666F72286C657420633D303B633C6C2E6C656E6774683B632B3D31297B6C657420683D6C5B635D2C733D6E6577206228682E782C682E792C682E70726573737572652C682E74696D65293B633D3D3D302626746869';
wwv_flow_imp.g_varchar2_table(141) := '732E5F72657365742861293B6C657420703D746869732E5F616464506F696E7428732C61293B7026266528702C61297D656C7365206C2E6C656E6774683D3D3D323F28746869732E5F72657365742861292C6F286C5B305D2C6C5B315D2C6129293A2874';
wwv_flow_imp.g_varchar2_table(142) := '6869732E5F72657365742861292C69286C5B305D2C6129297D7D746F535647287B696E636C7564654261636B67726F756E64436F6C6F723A743D21312C696E636C7564654461746155726C3A653D21317D3D7B7D297B6C657420693D746869732E5F6461';
wwv_flow_imp.g_varchar2_table(143) := '74612C6F3D4D6174682E6D61782877696E646F772E646576696365506978656C526174696F7C7C312C31292C723D302C6C3D302C613D746869732E63616E7661732E77696474682F6F2C633D746869732E63616E7661732E6865696768742F6F2C683D64';
wwv_flow_imp.g_varchar2_table(144) := '6F63756D656E742E637265617465456C656D656E744E532822687474703A2F2F7777772E77332E6F72672F323030302F737667222C2273766722293B696628682E7365744174747269627574652822786D6C6E73222C22687474703A2F2F7777772E7733';
wwv_flow_imp.g_varchar2_table(145) := '2E6F72672F323030302F73766722292C682E7365744174747269627574652822786D6C6E733A786C696E6B222C22687474703A2F2F7777772E77332E6F72672F313939392F786C696E6B22292C682E736574417474726962757465282276696577426F78';
wwv_flow_imp.g_varchar2_table(146) := '222C60247B727D20247B6C7D20247B617D20247B637D60292C682E73657441747472696275746528227769647468222C612E746F537472696E672829292C682E7365744174747269627574652822686569676874222C632E746F537472696E672829292C';
wwv_flow_imp.g_varchar2_table(147) := '742626746869732E6261636B67726F756E64436F6C6F72297B6C657420733D646F63756D656E742E637265617465456C656D656E7428227265637422293B732E73657441747472696275746528227769647468222C223130302522292C732E7365744174';
wwv_flow_imp.g_varchar2_table(148) := '747269627574652822686569676874222C223130302522292C732E736574417474726962757465282266696C6C222C746869732E6261636B67726F756E64436F6C6F72292C682E617070656E644368696C642873297D696628652626746869732E5F6461';
wwv_flow_imp.g_varchar2_table(149) := '746155726C297B6C657420733D746869732E5F6461746155726C4F7074696F6E733F2E726174696F7C7C77696E646F772E646576696365506978656C526174696F7C7C312C703D746869732E5F6461746155726C4F7074696F6E733F2E77696474687C7C';
wwv_flow_imp.g_varchar2_table(150) := '746869732E63616E7661732E77696474682F732C763D746869732E5F6461746155726C4F7074696F6E733F2E6865696768747C7C746869732E63616E7661732E6865696768742F732C643D746869732E5F6461746155726C4F7074696F6E733F2E784F66';
wwv_flow_imp.g_varchar2_table(151) := '667365747C7C302C5F3D746869732E5F6461746155726C4F7074696F6E733F2E794F66667365747C7C302C6D3D646F63756D656E742E637265617465456C656D656E742822696D61676522293B6D2E736574417474726962757465282278222C642E746F';
wwv_flow_imp.g_varchar2_table(152) := '537472696E672829292C6D2E736574417474726962757465282279222C5F2E746F537472696E672829292C6D2E73657441747472696275746528227769647468222C702E746F537472696E672829292C6D2E736574417474726962757465282268656967';
wwv_flow_imp.g_varchar2_table(153) := '6874222C762E746F537472696E672829292C6D2E73657441747472696275746528227072657365727665417370656374526174696F222C226E6F6E6522292C6D2E736574417474726962757465282268726566222C746869732E5F6461746155726C292C';
wwv_flow_imp.g_varchar2_table(154) := '682E617070656E644368696C64286D297D72657475726E20746869732E5F66726F6D4461746128692C28732C7B70656E436F6C6F723A707D293D3E7B6C657420763D646F63756D656E742E637265617465456C656D656E7428227061746822293B696628';
wwv_flow_imp.g_varchar2_table(155) := '2169734E614E28732E636F6E74726F6C312E782926262169734E614E28732E636F6E74726F6C312E792926262169734E614E28732E636F6E74726F6C322E782926262169734E614E28732E636F6E74726F6C322E7929297B6C657420643D604D20247B73';
wwv_flow_imp.g_varchar2_table(156) := '2E7374617274506F696E742E782E746F46697865642833297D2C247B732E7374617274506F696E742E792E746F46697865642833297D204320247B732E636F6E74726F6C312E782E746F46697865642833297D2C247B732E636F6E74726F6C312E792E74';
wwv_flow_imp.g_varchar2_table(157) := '6F46697865642833297D20247B732E636F6E74726F6C322E782E746F46697865642833297D2C247B732E636F6E74726F6C322E792E746F46697865642833297D20247B732E656E64506F696E742E782E746F46697865642833297D2C247B732E656E6450';
wwv_flow_imp.g_varchar2_table(158) := '6F696E742E792E746F46697865642833297D603B762E736574417474726962757465282264222C64292C762E73657441747472696275746528227374726F6B652D7769647468222C28732E656E6457696474682A322E3235292E746F4669786564283329';
wwv_flow_imp.g_varchar2_table(159) := '292C762E73657441747472696275746528227374726F6B65222C70292C762E736574417474726962757465282266696C6C222C226E6F6E6522292C762E73657441747472696275746528227374726F6B652D6C696E65636170222C22726F756E6422292C';
wwv_flow_imp.g_varchar2_table(160) := '682E617070656E644368696C642876297D7D2C28732C7B70656E436F6C6F723A702C646F7453697A653A762C6D696E57696474683A642C6D617857696474683A5F7D293D3E7B6C6574206D3D646F63756D656E742E637265617465456C656D656E742822';
wwv_flow_imp.g_varchar2_table(161) := '636972636C6522292C673D763E303F763A28642B5F292F323B6D2E736574417474726962757465282272222C672E746F537472696E672829292C6D2E73657441747472696275746528226378222C732E782E746F537472696E672829292C6D2E73657441';
wwv_flow_imp.g_varchar2_table(162) := '747472696275746528226379222C732E792E746F537472696E672829292C6D2E736574417474726962757465282266696C6C222C70292C682E617070656E644368696C64286D297D2C28732C702C76293D3E7B6C657420643D646F63756D656E742E6372';
wwv_flow_imp.g_varchar2_table(163) := '65617465456C656D656E7428226C696E6522293B642E73657441747472696275746528227831222C732E782E746F537472696E672829292C642E73657441747472696275746528227931222C732E792E746F537472696E672829292C642E736574417474';
wwv_flow_imp.g_varchar2_table(164) := '72696275746528227832222C702E782E746F537472696E672829292C642E73657441747472696275746528227932222C702E792E746F537472696E672829292C642E73657441747472696275746528227374726F6B65222C762E70656E436F6C6F72292C';
wwv_flow_imp.g_varchar2_table(165) := '642E73657441747472696275746528227374726F6B652D7769647468222C28746869732E5F676574446F7453697A652876292A32292E746F537472696E672829292C642E73657441747472696275746528227374726F6B652D6C696E65636170222C2272';
wwv_flow_imp.g_varchar2_table(166) := '6F756E6422292C682E617070656E644368696C642864297D292C682E6F7574657248544D4C7D7D7D293B6D6F64756C652E6578706F7274733D284428292C47285429292E64656661756C743B0A0A6966285F5F6578706F72747320213D206578706F7274';
wwv_flow_imp.g_varchar2_table(167) := '73296D6F64756C652E6578706F727473203D206578706F7274733B72657475726E206D6F64756C652E6578706F7274737D29293B0A2F2F2320736F757263654D617070696E6755524C3D7369676E61747572655F7061642E756D642E6D696E2E6A732E6D';
wwv_flow_imp.g_varchar2_table(168) := '61700A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(6148622704671968)
,p_plugin_id=>wwv_flow_imp.id(6145944884671963)
,p_file_name=>'signature_pad.umd.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
