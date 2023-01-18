#include "mui.h"
#include <string.h>

void button_event_handler(mui_event_details details, mui_window* window, void** app_data){
  mui_change_object_property(window, "label1", "{\"property\":\"text\",\"value\":\"Hello World!\"}");
  mui_change_object_property(window, "textbox1", "{\"property\":\"text\",\"value\":\"Hello World 2!\"}");
}

void textbox_event_handler(mui_event_details details, mui_window* window, void** app_data){
  struct mui_parsed_event_details parsed_details = mui_parse_event_details(details);
  char str[1024] = "{\"property\":\"text\",\"value\":\"";
  strcat(str, parsed_details.value);
  strcat(str, "\"}");
  mui_change_object_property(window, "label1", str);
}

void main(int argc, char** argv){
  mui_init(argc, argv);
  mui_window* window = mui_create("{\"title\":\"Hello World\", \"width\":450, \"height\":250}");
  mui_button(window, "{\"id\":\"button1\", \"x\":\"10%x\", \"y\":\"10\", \"width\":\"80%x\", \"text\": \"Button\"}", *button_event_handler);
  mui_label(window, "{\"id\":\"label1\", \"x\":\"10%x\", \"y\":\"50\", \"width\":\"80%x\", \"text\": \"This is a label\"}", *mui_empty_fn);
  mui_textbox(window, "{\"id\":\"textbox1\", \"x\":\"10%x\", \"y\":\"90\", \"width\":\"80%x\", \"text\": \"This is a textbox\"}", *textbox_event_handler);
  mui_run(window);
}
