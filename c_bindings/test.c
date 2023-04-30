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

void button2_event_handler(mui_event_details details, mui_window* window, void** app_data){
  mui_messagebox("Glitter ✨️", "A little glitter!", MUI_OK, MUI_INFO);
}

void textbox_event_handler(mui_event_details details, mui_window* window, void** app_data){
  printf("%d\n",++((struct AppData*)app_data)->count);
  struct mui_parsed_event_details parsed_details = mui_parse_event_details(details);
  mui_set_object_property_char(window, mui_get_object_by_id(window, "label1"), "text", parsed_details.value);
}

void image_event_handler(mui_event_details details, mui_window* window, void** app_data){
  struct mui_parsed_event_details parsed_details = mui_parse_event_details(details);
  mui_object* image1 = mui_get_object_by_id(window, parsed_details.target_id);
  char* file_path = mui_openfiledialog("Choose a image to view");
  mui_set_object_property_char (window, image1, "path", file_path);
}

int main(int argc, char** argv){
  struct AppData app_data;
  app_data.count = 0;
  
  mui_init(argc, argv);
  mui_window* window = mui_create("{\"title\":\"Hello World\", \"width\":450, \"height\":450}", (void*)&app_data);
  mui_button(window, "{\"id\":\"button1\", \"x\":\"10%x\", \"y\":\"10\", \"width\":\"80%x\", \"text\": \"Destroy the window\"}", *button_event_handler);
  mui_button(window, "{\"id\":\"button2\", \"x\":\"10\", \"y\":\"10\", \"width\":\"20\", \"height\":\"20\", \"icon\":\"true\", \"text\": \"✨️\"}", *button2_event_handler);
  mui_label(window, "{\"id\":\"label1\", \"x\":\"10%x\", \"y\":\"50\", \"width\":\"80%x\", \"text\": \"This is a label\"}", *mui_empty_fn);
  mui_textbox(window, "{\"id\":\"textbox1\", \"x\":\"10%x\", \"y\":\"90\", \"width\":\"80%x\", \"text\": \"This is a textbox\"}", *textbox_event_handler);
  mui_textarea(window, "{\"id\":\"textarea1\", \"x\":\"10%x\", \"y\":\"130\", \"width\":\"80%x -20\", \"height\":\"100\", \"text\": \"This is a textarea\"}", *mui_empty_fn);
  mui_image(window, "{\"id\":\"image1\", \"x\":\"10%x\", \"y\":\"250\", \"width\":\"64\", \"height\":\"64\", \"path\": \"../examples/v-logo.png\"}", *image_event_handler);
  mui_link(window, "{\"id\":\"link1\", \"x\":\"10%x +80\", \"y\":\"250\", \"width\":\"120\", \"link\": \"https://example.com\", \"text\":\"example.com\"}", *mui_empty_fn);
  mui_object* textarea1 = mui_get_object_by_id (window, "textarea1");
  mui_scrollbar(window, "{\"id\":\"scrollbar1\", \"x\":\"# 10%x\", \"y\":\"130\", \"width\":\"20\", \"height\":\"100\", \"vertical\":\"true\"}", *mui_empty_fn, *mui_empty_fn, *mui_empty_fn, textarea1);
  mui_run(window);
  return 0;
}
