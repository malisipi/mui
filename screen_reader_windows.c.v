module mui

import os

#include "@VMODROOT/native/windows_core_helper.h"

fn C.mui_does_narrator_alive() bool

const(
	narrator_vbs=os.temp_dir()+"/mui_speak.vbs"
)
