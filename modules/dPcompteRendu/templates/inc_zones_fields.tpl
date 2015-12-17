{{assign var=mode_play value=$app->user_prefs.mode_play}}
{{assign var=check_to_empty_field value=$conf.dPcompteRendu.CCompteRendu.check_to_empty_field}}

<table>
  {{if $isCourrier}}
    <tr>
      <td>
        <button type="button" class="mail singleclick"
          onclick="
          {{if $compte_rendu->_id}}
            openCorrespondants('{{$compte_rendu->_id}}', '{{$compte_rendu->_ref_object->_guid}}', 1);
          {{else}}
            var form = getForm('editFrm');
            var nb_corres = form.select('input[type=checkbox]:checked');
            submitCompteRendu(function() {
              var form = getForm('editFrm');
              var editor = CKEDITOR.instances.htmlarea;

              if (nb_corres.length == 0) {
                openCorrespondants($V(form.compte_rendu_id), '{{$compte_rendu->_ref_object->_guid}}', 1);
              }
              if (editor.getCommand('save')) {
                editor.getCommand('save').setState(CKEDITOR.TRISTATE_OFF);
              }
              if (editor.getCommand('mbprint')) {
                editor.getCommand('mbprint').setState(CKEDITOR.TRISTATE_OFF);
              }
              if (editor.getCommand('mbprintPDF')) {
                editor.getCommand('mbprintPDF').setState(CKEDITOR.TRISTATE_OFF);
              }

            });
          {{/if}}">
          Correspondants
        </button>
        <div id="correspondants_courrier" style="display: none; width: 50%"></div>
      </td>
      {{if $destinataires|@count}}
        <td id="destinataires" class="text">
          {{foreach from=$destinataires key=curr_class_name item=curr_class}}
            &bull; <strong>{{tr}}{{$curr_class_name}}{{/tr}}</strong> :
            {{foreach from=$curr_class key=curr_index item=curr_dest}}
              <span>
                <label>
                <input type="checkbox" name="_dest_{{$curr_class_name}}_{{$curr_index}}" />
                  {{$curr_dest->nom}} ({{tr}}CDestinataire.tag.{{$curr_dest->tag}}{{/tr}});
                </label>
              </span>
            {{/foreach}}
            <br />
          {{/foreach}}
        </td>
      {{/if}}
    </tr>
  {{/if}}
  {{if $lists|@count}}
    <tr>
      <td id="liste" colspan="2" {{if $mode_play}}style="display: none;"{{/if}}>
        <!-- The div is required because of a Webkit float issue -->
        <div class="listeChoixCR">
          {{foreach from=$lists item=curr_list}}
            {{math equation=min(x,y) x=$curr_list->_valeurs|@count y=25 assign=size}}
            <select name="_{{$curr_list->_class}}[{{$curr_list->_id}}][]" data-nom="{{$curr_list->nom}}"
            {{if $mode_play}}size="{{$size}}" multiple="true"{{/if}}
            {{if !$check_to_empty_field}}onchange="this.form.elements['_empty_list[{{$curr_list->_id}}]'].checked='checked'"{{/if}}>
              <option value="undef">&mdash; {{$curr_list->nom}}</option>
              {{foreach from=$curr_list->_valeurs item=curr_valeur}}
                <option value="{{$curr_valeur}}" title="{{$curr_valeur}}">{{$curr_valeur|truncate}}</option>
              {{/foreach}}
            </select>
            <input type="checkbox" name="_empty_list[{{$curr_list->_id}}]" title="{{tr}}CListeChoix.fill{{/tr}}"/>
          {{/foreach}}
        </div>
      </td>
    </tr>
  {{/if}}
  
  {{if $textes_libres|@count}}
    <tr {{if $mode_play}}style="display: none;"{{/if}}>
      <td colspan="2" class="text textelibreCR">
      {{foreach from=$textes_libres item=_nom}}
        <div {{if !$mode_play}}style="max-width: 200px; display: inline-block;"{{/if}} data-nom="{{$_nom}}">
          {{if !$mode_play}}
            <input type="checkbox" name="_empty_texte_libre[{{$_nom|md5}}]" title="{{tr}}CListeChoix.fill{{/tr}}" class="empty_field"/>
          {{/if}}
          {{$_nom|html_entity_decode}}
          <textarea class="freetext" name="_texte_libre[{{$_nom|md5}}]" id="editFrm__texte_libre[{{$_nom|md5}}]"
          {{if !$mode_play && !$check_to_empty_field}}
            onkeydown="this.form.elements['_empty_texte_libre[{{$_nom|md5}}]'].checked='checked'; this.onkeydown=''"
          {{/if}}></textarea>
          <input type="hidden" name="_texte_libre_md5[{{$_nom|md5}}]" value="{{$_nom}}"/>
        </div>
        {{main}}
          new AideSaisie.AutoComplete('editFrm__texte_libre[{{$_nom|md5}}]',
          {
            objectClass: '{{$compte_rendu->_class}}',
            contextUserId: User.id,
            contextUserView: "{{$user_view|smarty:nodefaults|JSAttribute}}",
            timestamp: "{{$conf.dPcompteRendu.CCompteRendu.timestamp}}",
            resetSearchField: false,
            resetDependFields: false,
            validateOnBlur: false,
            property: "_source"
          });
          
          var textarea = $('editFrm__texte_libre[{{$_nom|md5}}]');  
          if (!textarea.up().hasClassName("textarea-container"))
            textarea.setResizable({autoSave: true, step: 'font-size'});
        {{/main}}
      {{/foreach}}
      </td>
    </tr>
  {{/if}}
  
  {{if ($textes_libres|@count || $lists|@count) && !$mode_play}}
    <tr>
      <td class="button text" colspan="2">
        <div id="multiple-info" class="small-info" style="display: none;">
          {{tr}}CCompteRendu-use-multiple-choices{{/tr}}
        </div>
        <script type="text/javascript">
          function toggleOptions() {
            $$("#liste select").each(function(select) {
              select.size = select.size != 4 ? 4 : 1;
              select.multiple = !select.multiple;
              select.options[0].selected = false;
            } );
            $("multiple-info").toggle();
          }
        </script>
        <button class="hslip" type="button" onclick="toggleOptions();">{{tr}}Multiple options{{/tr}}</button>
        <button class="tick" type="button" onclick="getForm('editFrm').onsubmit()">{{tr}}Save{{/tr}}</button>
      </td>
    </tr>
  {{/if}}
</table>