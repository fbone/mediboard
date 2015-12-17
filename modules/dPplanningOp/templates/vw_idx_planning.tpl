<!-- $Id: vw_idx_planning.tpl 28167 2015-05-04 15:38:23Z flaviencrochard $ -->
{{mb_script module="compteRendu" script="modele_selector"}}
{{mb_script module="compteRendu" script="document"}}
{{mb_script module="patients"    script="documentV2"}}
{{mb_script module="planningOp"  script="operation"}}

<script>
  updateListOperations = function(date) {
    var url = new Url("dPplanningOp", "httpreq_vw_list_operations");
    url.addParam("pratSel" , "{{$selPrat}}");
    url.addParam("canceled", "{{$canceled}}");
    if(date) {
      url.addParam("date"    , date);
    }

    var checkboxes = $$('input[name="showPlage"]:not(:checked)');
    var hidden_plages = [];
    checkboxes.each(function(checkbox) {
      hidden_plages.push(checkbox.getAttribute('data-plage_id'));
    });
    url.addParam('hiddenPlages', hidden_plages.join('|'));

    url.requestUpdate('operations');

    var row = $("date-"+date);
    if (row) {
      row.addUniqueClassName("selected");
    }

    return false;
  };

  refreshListPlage = function() {
    var url = new Url('planningOp', 'vw_idx_planning');
    url.addParam('date', '{{$date}}');
    url.addParam('selPrat', '{{$selPrat}}');
    url.addParam('canceled', '{{$canceled}}');
    url.addParam('refresh', 1);
    url.requestUpdate('didac_list_interv');
  };

  Main.add(function () {
    updateListOperations("{{$date}}");
  });
</script>

<table class="main">
  <tr>
    <th style="height: 16px;">
      <form name="selectPraticien" method="get">
        <input type="hidden" name="m" value="{{$m}}" />
        <input type="hidden" name="tab" value="{{$tab}}" />
        <select name="selPrat" onchange="this.form.submit()" style="max-width: 150px;">
          <option value="-1">&mdash; Choisir un praticien</option>
          {{mb_include module=mediusers template=inc_options_mediuser list=$listPrat selected=$selPrat}}
        </select>
      </form>
    </th>
    <td id="didac_operations" rowspan="3" class="greedyPane" style="vertical-align:top;">
      <div id="operations">
        <div class="small-info">
          Cette vue affiche la liste des interventions pour le jour s�lectionn�.
        </div>
      </div>
    </td>
  </tr>
  
  <tr>
    <th style="height: 16px;">
      <a href="?m={{$m}}&tab={{$tab}}&date={{$lastmonth}}">&lt;&lt;&lt;</a>
      {{$date|date_format:"%B %Y"}}
      <a href="?m={{$m}}&tab={{$tab}}&date={{$nextmonth}}">&gt;&gt;&gt;</a>
    </th>
  </tr>
  
  <tr>
    <td>
      <table id="didac_list_interv" class="tbl">
        {{mb_include module=planningOp template=inc_list_plagesop}}
      </table>
    </td>
  </tr>
</table>