#warning "The API is unstable and a lot of thing will be changed in future. Please don't use in real-world application before stable-release."

typedef struct mui_window mui_window;
typedef struct mui_event_details mui_event_details;
typedef struct mui_parsed_event_details mui_parsed_event_details;
typedef struct v_string v_string;

struct v_string {
  int* str;
  int len;
  int is_lit;
};

struct mui_event_details {
  v_string event;
  v_string trigger;
  v_string value;
  v_string target_type;
  v_string target_id;
};

struct mui_parsed_event_details {
  char* event;
  char* trigger;
  char* value;
  char* target_type;
  char* target_id;
};

struct mui_window {};

void mui_init(int argc, char** argv);
mui_window* mui_create(char* config);
void mui_button(mui_window* window, char* config, void (*onclk)(mui_event_details, mui_window*, void**));
void mui_label(mui_window* window, char* config, void (*onclk)(mui_event_details, mui_window*, void**));
void mui_textbox(mui_window* window, char* config, void (*onchg)(mui_event_details, mui_window*, void**));
void mui_run(mui_window* window);
void mui_change_object_property(mui_window* window, char* id, char* config);
struct mui_parsed_event_details mui_parse_event_details(mui_event_details);
void mui_empty_fn(mui_event_details details, mui_window* window, void** app_data){}

/*
### Not Implemented Yet ###

void mui_get_object_by_id();
void mui_sort_widgets_with_zindex();
void mui_destroy();
void mui_notifypopup();
void mui_openfiledialog();
void mui_passwordbox();
void mui_savefiledialog();
void mui_selectfolderdialog();
void mui_inputbox();
void mui_messagebox();
void mui_beep();
void mui_colorchooser();
*/
