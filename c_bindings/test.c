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

void checkbox_event_handler(mui_event_details details, mui_window* window, void** app_data){
  struct mui_parsed_event_details parsed_details = mui_parse_event_details(details);
  if(!strcmp(parsed_details.value, "true")){
    mui_messagebox("Why?", "Why? Can you explain?", MUI_WARNING, MUI_INFO);
  }
}

void slider_event_handler(mui_event_details details, mui_window* window, void** app_data){
  struct mui_parsed_event_details parsed_details = mui_parse_event_details(details);
  int scale;
  char size[4];
  sscanf(parsed_details.value, "%d", &scale);
  mui_object* image = mui_get_object_by_id(window, "image1");
  sprintf(size, "%d", scale*10);
  mui_set_object_property_char(window, image, "h_raw", size);
  mui_set_object_property_char(window, image, "w_raw", size);
}

void init_handler(mui_event_details details, mui_window* window, void** app_data){
  printf("%s\n","Hi!");
}

void quit_handler(mui_event_details details, mui_window* window, void** app_data){
  printf("%s\n","Good Bye!");
}

int main(int argc, char** argv){
  struct AppData app_data;
  app_data.count = 0;
  
  mui_init(argc, argv);
  mui_register_fn ("init", *init_handler);
  mui_register_fn ("quit", *quit_handler);
  mui_window* window = mui_create("{\"title\":\"Hello World\", \"width\":450, \"height\":450}", (void*)&app_data);

  mui_register_fn("click", *button_event_handler);
  mui_button(window, "{\"id\":\"button1\", \"x\":\"10%x\", \"y\":\"10\", \"width\":\"80%x\", \"text\": \"Destroy the window\"}");

  mui_register_fn ("click", *button2_event_handler);
  mui_button(window, "{\"id\":\"button2\", \"x\":\"10\", \"y\":\"10\", \"width\":\"20\", \"height\":\"20\", \"icon\":\"true\", \"text\": \"✨️\"}");

  mui_label(window, "{\"id\":\"label1\", \"x\":\"10%x\", \"y\":\"50\", \"width\":\"80%x\", \"text\": \"This is a label\"}");

  mui_register_fn("change", *textbox_event_handler);
  mui_textbox(window, "{\"id\":\"textbox1\", \"x\":\"10%x\", \"y\":\"90\", \"width\":\"80%x\", \"text\": \"This is a textbox\"}");

  mui_textarea(window, "{\"id\":\"textarea1\", \"x\":\"10%x\", \"y\":\"130\", \"width\":\"80%x -20\", \"height\":\"100\", \"text\": \"This is a textarea\", \"codefield\":\"true\"}");

  mui_register_fn("click", *image_event_handler);
  mui_image(window, "{\"id\":\"image1\", \"x\":\"10%x\", \"y\":\"250\", \"width\":\"64\", \"height\":\"64\", \"path\": \"../examples/v-logo.png\"}");

  mui_link(window, "{\"id\":\"link1\", \"x\":\"10%x +80\", \"y\":\"250\", \"width\":\"120\", \"link\": \"https://example.com\", \"text\":\"example.com\"}");

  mui_register_fn("change", *checkbox_event_handler);
  mui_checkbox(window, "{\"id\":\"checkbox1\", \"x\":\"10%x +80\", \"y\":\"280\", \"width\":\"20\", \"text\":\"Do not check it!\"}");

  mui_register_fn("change", *checkbox_event_handler);
  mui_switch(window, "{\"id\":\"switch1\", \"x\":\"10%x +80\", \"y\":\"310\", \"width\":\"50\", \"text\":\"Do not check it!\"}");

  mui_register_fn("change", *slider_event_handler);
  mui_slider(window, "{\"id\":\"slider1\", \"x\":\"10%x\", \"y\":\"350\", \"width\":\"100\", \"height\":\"20\"}");

  mui_object* textarea1 = mui_get_object_by_id (window, "textarea1");
  mui_scrollbar(window, "{\"id\":\"scrollbar1\", \"x\":\"# 10%x\", \"y\":\"130\", \"width\":\"20\", \"height\":\"100\", \"vertical\":\"true\"}", textarea1);

  mui_run(window);
  return 0;
}
