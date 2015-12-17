{{* $Id: view_import.tpl 14702 2012-02-21 09:34:10Z phenxdesign $ *}}

{{*
 * @package Mediboard
 * @subpackage forms
 * @version $Revision: 14702 $
 * @author SARL OpenXtrem
 * @license GNU General Public License, see http://www.gnu.org/licenses/gpl.html
*}}

<script type="text/javascript">
onUploadComplete = function(message){
  SystemMessage.notify(message);
}
</script>

<form name="import-form" action="?m=forms&amp;a=do_import" method="post" 
      onsubmit="return checkForm(this)" target="upload_iframe" enctype="multipart/form-data">
  <input type="hidden" name="m" value="forms" />
  <input type="hidden" name="a" value="do_import" />
  <input type="hidden" name="suppressHeaders" value="1" />
	
	<table class="main form" style="table-layout: fixed;">
		<tr>
			<th class="title" colspan="2">
				Importation
			</th>
		</tr>
		
		<tr>
			<th>
				<label for="object_class">Type d'�l�ments � importer</label>
			</th>
			<td>
		    <select name="object_class" class="notNull">
		    	<option value=""> &ndash; Choisir un type d'�lement � importer </option>
		      {{foreach from=$classes item=_class}}
		        <option value="{{$_class}}">{{tr}}{{$_class}}{{/tr}}</option>
		      {{/foreach}}
		    </select>
			</td>
		</tr>
		
		<tr>
			<th>
				<label for="import">Fichier</label>
			</th>
			<td>
		    <input type="hidden" name="MAX_FILE_SIZE" value="4096000" />
		    <input type="file" name="import" style="width: 20em;" class="notNull" />
			</td>
		</tr>
		
		<tr>
			<th></th>
      <td>
        <button type="submit" class="submit">{{tr}}Save{{/tr}}</button>
      </td>
		</tr>
	</table>
</form>

<iframe name="upload_iframe" style="display: none;"></iframe>