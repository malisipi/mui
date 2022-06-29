module mui

import gg
import os

fn get_capslock_status() bool {
    mut state:=false
    $if windows {
        state=C.GetKeyState(C.VK_CAPITAL)
    } $else $if linux {
        if os.getenv("XDG_SESSION_TYPE")=="x11" && os.exists_in_system_path("sed") && os.exists_in_system_path("xset"){
            output:=os.execute("xset -q | sed -n 's/^.*Caps Lock:\\s*\\(\\S*\\).*$/\\1/p'")
            state=output.output.replace("\n","").replace("\r","").replace(" ","")=="on"
        } else {
            output:=os.execute("cat /sys/class/leds/input*::capslock/brightness")
            state=output.output.replace("\n","").replace("\r","").replace(" ","")[0..1]=="1"
        }
    }
    return state
}

fn parse_key(c gg.KeyCode, m gg.Modifier) string{
	super := m == .super
	shift := m == .shift
	alt   := m == .alt
	ctrl  := m == .ctrl
	mut key:=""
	if super {
		print("TO DO")
	} else if ctrl {
		print("TO DO") //Shortcuts like CTRL+S
	} else if alt {
		print("TO DO")
	} else {
		match c {
			.space{ key=" "}
			.a { key="a" }
			.b { key="b" }
			.c { key="c" }
			.d { key="d" }
			.e { key="e" }
			.f { key="f" }
			.g { key="g" }
			.h { key="h" }
			.i { key="i" }
			.j { key="j" }
			.k { key="k" }
			.l { key="l" }
			.m { key="m" }
			.n { key="n" }
			.o { key="o" }
			.p { key="p" }
			.r { key="r" }
			.s { key="s" }
			.t { key="t" }
			.u { key="u" }
			.v { key="v" }
			.y { key="y" }
			.z { key="z" }
			.x { key="x" }
			.q { key="q" }
			.w { key="w" }
			._0 { key="0" }
			._1 { key="1" }
			._2 { key="2" }
			._3 { key="3" }
			._4 { key="4" }
			._5 { key="5" }
			._6 { key="6" }
			._7 { key="7" }
			._8 { key="8" }
			._9 { key="9" }
			.kp_0 { key="0" }
			.kp_1 { key="1" }
			.kp_2 { key="2" }
			.kp_3 { key="3" }
			.kp_4 { key="4" }
			.kp_5 { key="5" }
			.kp_6 { key="6" }
			.kp_7 { key="7" }
			.kp_8 { key="8" }
			.kp_9 { key="9" }
			.apostrophe { key="'" }
			.comma { key="," }
			.period { key="."}
			.minus { key="-" }
			.slash { key="/" }
			.semicolon { key=";" }
			.equal { key="=" }
			.escape { key="escape" }
			.enter { key="enter" }
			.tab { key="tab" }
			.backspace { key="\b" }
			.kp_divide { key="/" }
			.kp_equal { key="=" }
			.kp_add { key="+" }
			.kp_multiply { key="*" }
			.kp_subtract { key="-" }
			.menu { key="menu" }
			.right { key="right" }
			.left { key="left" }
			.down { key="down" }
			.up { key="up" }
			else {}
		}
	}

	if shift!=get_capslock_status() {
		return key.to_upper()
	} else {
		return key
	}
}
