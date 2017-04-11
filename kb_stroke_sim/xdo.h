
#ifndef _XDO_H_
#define _XDO_H_

#ifndef __USE_XOPEN
#define __USE_XOPEN
#endif /* __USE_XOPEN */

#include <sys/types.h>
#include <X11/Xlib.h>
#include <X11/X.h>
#include <unistd.h>
#include <wchar.h>

#define SIZE_USEHINTS (1L << 0)
#define SIZE_USEHINTS_X (1L << 1)
#define SIZE_USEHINTS_Y (1L << 2)

#define CURRENTWINDOW (0)

typedef struct keysym_charmap {
  const char *keysym;
  wchar_t key;
} keysym_charmap_t;

typedef struct charcodemap {
  wchar_t key; 
  KeyCode code; 
  KeySym symbol; 
  int index; 
  int modmask; 
  int needs_binding;
} charcodemap_t;

typedef enum {
  XDO_FEATURE_XTEST, 
} XDO_FEATURES;

typedef struct xdo {

  Display *xdpy;

  char *display_name;

  charcodemap_t *charcodes;

  int charcodes_len;

  XModifierKeymap *modmap;

  KeySym *keymap;

  int keycode_high; /* highest and lowest keycodes */

  int keycode_low;  /* used by this X server */
  
  int keysyms_per_keycode;

  int close_display_when_freed;

  int quiet;

  int debug;

  int features_mask;

} xdo_t;


typedef struct xdo_active_mods {
  charcodemap_t *keymods;
  int nkeymods;
  unsigned int input_state;
} xdo_active_mods_t;


#define SEARCH_TITLE (1UL << 0)

#define SEARCH_CLASS (1UL << 1)

#define SEARCH_NAME (1UL << 2)

#define SEARCH_PID  (1UL << 3)

#define SEARCH_ONLYVISIBLE  (1UL << 4)

#define SEARCH_SCREEN  (1UL << 5)

#define SEARCH_CLASSNAME (1UL << 6)

#define SEARCH_DESKTOP (1UL << 7)


typedef struct xdo_search {
  const char *title;        
  const char *winclass;     
  const char *winclassname; 
  const char *winname;      
  int pid;            
  long max_depth;     
  int only_visible;   
  int screen;         
  enum { SEARCH_ANY, SEARCH_ALL } require;
  
  unsigned int searchmask; 

  long desktop;

  unsigned int limit;
} xdo_search_t;

#define XDO_ERROR 1
#define XDO_SUCCESS 0

xdo_t* xdo_new(char *display);

xdo_t* xdo_new_with_opened_display(Display *xdpy, const char *display,
                                   int close_display_when_freed);

const char *xdo_version(void);

void xdo_free(xdo_t *xdo);

int xdo_mousemove(const xdo_t *xdo, int x, int y, int screen);

int xdo_mousemove_relative_to_window(const xdo_t *xdo, Window window, int x, int y);

int xdo_mousemove_relative(const xdo_t *xdo, int x, int y);

int xdo_mousedown(const xdo_t *xdo, Window window, int button);

int xdo_mouseup(const xdo_t *xdo, Window window, int button);

int xdo_mouselocation(const xdo_t *xdo, int *x, int *y, int *screen_num);

int xdo_mousewindow(const xdo_t *xdo, Window *window_ret);

int xdo_mouselocation2(const xdo_t *xdo, int *x_ret, int *y_ret,
                       int *screen_num_ret, Window *window_ret);

int xdo_mouse_wait_for_move_from(const xdo_t *xdo, int origin_x, int origin_y);

int xdo_mouse_wait_for_move_to(const xdo_t *xdo, int dest_x, int dest_y);

int xdo_click(const xdo_t *xdo, Window window, int button);

int xdo_click_multiple(const xdo_t *xdo, Window window, int button,
                       int repeat, useconds_t delay);

int xdo_type(const xdo_t *xdo, Window window, const char *string, useconds_t delay);

int xdo_keysequence(const xdo_t *xdo, Window window,
                    const char *keysequence, useconds_t delay);

int xdo_keysequence_up(const xdo_t *xdo, Window window,
                       const char *keysequence, useconds_t delay);

int xdo_keysequence_down(const xdo_t *xdo, Window window,
                         const char *keysequence, useconds_t delay);
                         
int xdo_keysequence_list_do(const xdo_t *xdo, Window window,
                            charcodemap_t *keys, int nkeys,
                            int pressed, int *modifier, useconds_t delay);

int xdo_active_keys_to_keycode_list(const xdo_t *xdo, charcodemap_t **keys,
                                         int *nkeys);

int xdo_window_wait_for_map_state(const xdo_t *xdo, Window wid, int map_state);

#define SIZE_TO 0
#define SIZE_FROM 1
int xdo_window_wait_for_size(const xdo_t *xdo, Window window, unsigned int width,
                             unsigned int height, int flags, int to_or_from);


int xdo_window_move(const xdo_t *xdo, Window wid, int x, int y);

int xdo_window_translate_with_sizehint(const xdo_t *xdo, Window window,
                                       int width, int height, int *width_ret,
                                       int *height_ret);

int xdo_window_setsize(const xdo_t *xdo, Window wid, int w, int h, int flags);

int xdo_window_setprop (const xdo_t *xdo, Window wid, const char *property,
                        const char *value);

int xdo_window_setclass(const xdo_t *xdo, Window wid, const char *name,
                        const char *class);

int xdo_window_seturgency (const xdo_t *xdo, Window wid, int urgency);

int xdo_window_set_override_redirect(const xdo_t *xdo, Window wid,
                                     int override_redirect);

int xdo_window_focus(const xdo_t *xdo, Window wid);

int xdo_window_raise(const xdo_t *xdo, Window wid);

int xdo_window_get_focus(const xdo_t *xdo, Window *window_ret);

int xdo_window_wait_for_focus(const xdo_t *xdo, Window window, int want_focus);

int xdo_window_get_pid(const xdo_t *xdo, Window window);

int xdo_window_sane_get_focus(const xdo_t *xdo, Window *window_ret);

int xdo_window_activate(const xdo_t *xdo, Window wid);

int xdo_window_wait_for_active(const xdo_t *xdo, Window window, int active);

int xdo_window_map(const xdo_t *xdo, Window wid);

int xdo_window_unmap(const xdo_t *xdo, Window wid);

int xdo_window_minimize(const xdo_t *xdo, Window wid);

int xdo_window_reparent(const xdo_t *xdo, Window wid_source, Window wid_target);

int xdo_get_window_location(const xdo_t *xdo, Window wid,
                            int *x_ret, int *y_ret, Screen **screen_ret);

int xdo_get_window_size(const xdo_t *xdo, Window wid, unsigned int *width_ret,
                        unsigned int *height_ret);

/* pager-like behaviors */

int xdo_window_get_active(const xdo_t *xdo, Window *window_ret);

int xdo_window_select_with_click(const xdo_t *xdo, Window *window_ret);

int xdo_set_number_of_desktops(const xdo_t *xdo, long ndesktops);

int xdo_get_number_of_desktops(const xdo_t *xdo, long *ndesktops);

int xdo_set_current_desktop(const xdo_t *xdo, long desktop);

int xdo_get_current_desktop(const xdo_t *xdo, long *desktop);

int xdo_set_desktop_for_window(const xdo_t *xdo, Window wid, long desktop);

int xdo_get_desktop_for_window(const xdo_t *xdo, Window wid, long *desktop);

int xdo_window_search(const xdo_t *xdo, const xdo_search_t *search,
                      Window **windowlist_ret, int *nwindows_ret);

unsigned char *xdo_getwinprop(const xdo_t *xdo, Window window, Atom atom,
                              long *nitems, Atom *type, int *size);

unsigned int xdo_get_input_state(const xdo_t *xdo);

const keysym_charmap_t *xdo_keysym_charmap(void);

const char **xdo_symbol_map(void);

/* active modifiers stuff */

xdo_active_mods_t *xdo_get_active_modifiers(const xdo_t *xdo);

int xdo_clear_active_modifiers(const xdo_t *xdo, Window window,
                               xdo_active_mods_t *active_mods);

int xdo_set_active_modifiers(const xdo_t *xdo, Window window,
                             const xdo_active_mods_t *active_mods);

void xdo_free_active_modifiers(xdo_active_mods_t *active_mods);

int xdo_get_desktop_viewport(const xdo_t *xdo, int *x_ret, int *y_ret);

int xdo_set_desktop_viewport(const xdo_t *xdo, int x, int y);

int xdo_window_kill(const xdo_t *xdo, Window window);

#define XDO_FIND_PARENTS (0)

#define XDO_FIND_CHILDREN (1)

int xdo_window_find_client(const xdo_t *xdo, Window window, Window *window_ret,
                           int direction);

int xdo_get_window_name(const xdo_t *xdo, Window window, 
                        unsigned char **name_ret, int *name_len_ret,
                        int *name_type);

void xdo_disable_feature(xdo_t *xdo, int feature);

void xdo_enable_feature(xdo_t *xdo, int feature);

int xdo_has_feature(xdo_t *xdo, int feature);

int xdo_get_viewport_dimensions(xdo_t *xdo, unsigned int *width,
                                unsigned int *height, int screen);
#endif /* ifndef _XDO_H_ */
