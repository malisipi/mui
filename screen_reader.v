module mui

import os

fn check_screen_reader() bool {
    $if linux {

	    mut output:=os.execute("")

		if os.exists_in_system_path("dconf"){
			output=os.execute("dconf read /org/gnome/desktop/a11y/applications/screen-reader-enabled")
		} else if os.exists_in_system_path("gsettings") {
			output=os.execute("gsettings get org.gnome.desktop.a11y.applications screen-reader-enabled")
		}

		if !os.exists_in_system_path("espeak-ng"){ return false }

		return output.output.replace("\n","").replace("\r","").replace("'","")=="true"

    } $else $if windows {
        $if !tinyc {
            if C.mui_does_narrator_alive() {
	          os.write_file(narrator_vbs ,"if WScript.Arguments.Count = 1 then CreateObject(\"sapi.spvoice\").Speak WScript.Arguments(0)") or {return false}
      	    return true
            } else { return false }
        }
        return false
    } $else {
        return false
    }
}

fn screen_reader_remove_scepical_chars(text string) string{
    mut temp:=text
    for chr in ["(",")","$","#","&","%","^","'","!",";",".",":",";","\"","~","/","\\","-","|"]{
        temp=temp.replace(chr,"")
    }

    $if windows{
        return temp
    }
    return temp.replace(" ","\\ ")
}

fn screen_reader_read(text string){
    $if linux{
        if text.trim(" ").len>0{
            os.execute("espeak-ng "+screen_reader_remove_scepical_chars(text))
        }
    } $else $if windows {
        if text.trim(" ").len>0{
            os.execute("cmd.exe /c cscript.exe //U //Nologo \""+narrator_vbs+"\" \""+screen_reader_remove_scepical_chars(text)+"\"")
        }
    }
}

@[unsafe]
fn (mut app Window) screen_reader_parse_text(object_id string) string{
    unsafe {
        if object_id!=""{
            mut object:=app.get_object_by_id(object_id)[0]
            if app.active_dialog!=""{
                object=app.get_dialog_object_by_id(object_id)[0]
            }
            if object["type"].str=="button" || object["type"].str=="checkbox" || object["type"].str=="radio" || object["type"].str=="selectbox" || object["type"].str=="label" || object["type"].str=="link"{
                return object["text"].str
            } else if object["type"].str=="textbox" {
                return object["ph"].str+" "+object["text"].str
            } else if object["type"].str=="password" {
                return object["ph"].str
            } else if object["type"].str=="progress" {
                return object["perc"].num.str()+" percent"
            }
        }
        return ""
    }
}
