#define DEBUG_MODE 1

#define ANSI_COLOR_RESULT     "\x1b[31;1m" // red color
#define ANSI_COLOR_RESET   "\x1b[0m"	//default color
#define ANSI_COLOR_DEBUG     "\x1b[37;1m" // white color


#define DEBUG(fmt, ...) do { if (DEBUG_MODE) fprintf(stderr, ANSI_COLOR_DEBUG "%s:%d:%s(): " fmt ANSI_COLOR_RESET "\n", __FILE__, __LINE__, __func__, __VA_ARGS__); } while (0)
