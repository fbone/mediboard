{{$map_tympan|smarty:nodefaults}}
<img id="tympan_{{$side}}" src="?m=dPcabinet&amp;a=graph_audio_tympan&amp;suppressHeaders=1&amp;examaudio_id={{$exam_audio->_id}}&amp;side={{$side}}&amp;time={{$time}}" usemap="#graph_tympan_{{$side}}" onclick="changeTympanValueMouse{{$fctOnClick}}(event)" alt="Tympa {{$fctOnClick}}" />