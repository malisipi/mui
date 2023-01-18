#warning "The API is unstable and a lot of thing will be changed in future. Please don't use in real-world application before stable-release."

#define MUI_OK "ok"
#define MUI_OK_CANCEL "okcancel"
#define MUI_YES_NO "yesno"
#define MUI_YES_NO_CANCEL "yesnocancel"
#define MUI_INFO "info"
#define MUI_WARNING "warning"
#define MUI_ERROR "error"
#define MUI_RETURN_CANCEL_NO 0
#define MUI_RETURN_OK_YES 1
#define MUI_RETURN_NO 2 //On Yes/No/Cancel

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
void mui_destroy(mui_window* window);
int mui_messagebox(char* title, char* message, char* typ, char* icon);
void mui_beep();
char* mui_inputbox(char* title, char* text, char* default_text);

/*
### Not Implemented Yet ###

void mui_get_object_by_id();
void mui_sort_widgets_with_zindex();
void mui_notifypopup();
void mui_openfiledialog();
void mui_passwordbox();
void mui_savefiledialog();
void mui_selectfolderdialog();
void mui_inputbox();
void mui_colorchooser();
*/
