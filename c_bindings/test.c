#include "mui.h"
#include <string.h>
#include <stdio.h>

struct AppData {
  int count;
};

void button_event_handler(mui_event_details details, mui_window* window, void** app_data){
  mui_messagebox("Goodbye!", 
    mui_inputbox("Say last words!","The last words:","Last words")
  , MUI_OK, MUI_INFO);
  mui_destroy(window);
}

void textbox_event_handler(mui_event_details details, mui_window* window, void** app_data){
  printf("%d\n",++((struct AppData*)app_data)->count);
  struct mui_parsed_event_details parsed_details = mui_parse_event_details(details);
  char str[256] = "{\"property\":\"text\",\"value\":\"";
  strcat(str, parsed_details.value);
  strcat(str, "\"}");
  mui_change_object_property(window,
    mui_get_object_by_id(window, "label1"),
    str);
}

int main(int argc, char** argv){
  struct AppData app_data;
  app_data.count = 0;
  
  mui_init(argc, argv);
  mui_window* window = mui_create("{\"title\":\"Hello World\", \"width\":450, \"height\":250}", (void*)&app_data);
  mui_button(window, "{\"id\":\"button1\", \"x\":\"10%x\", \"y\":\"10\", \"width\":\"80%x\", \"text\": \"Destroy the window\"}", *button_event_handler);
  mui_label(window, "{\"id\":\"label1\", \"x\":\"10%x\", \"y\":\"50\", \"width\":\"80%x\", \"text\": \"This is a label\"}", *mui_empty_fn);
  mui_textbox(window, "{\"id\":\"textbox1\", \"x\":\"10%x\", \"y\":\"90\", \"width\":\"80%x\", \"text\": \"This is a textbox\"}", *textbox_event_handler);
  mui_textarea(window, "{\"id\":\"textarea1\", \"x\":\"10%x\", \"y\":\"130\", \"width\":\"80%x -20\", \"height\":\"100\", \"text\": \"This is a textarea\"}", *mui_empty_fn);
  mui_object* textarea1 = mui_get_object_by_id (window, "textarea1");
  mui_scrollbar(window, "{\"id\":\"scrollbar1\", \"x\":\"# 10%x\", \"y\":\"130\", \"width\":\"20\", \"height\":\"100\", \"vertical\":\"true\"}", *mui_empty_fn, *mui_empty_fn, *mui_empty_fn, textarea1);
  mui_run(window);
  return 0;
}
