#include "cold-c.h"
#include <stdio.h>

int itoa(char *result, int value) {
    return sprintf(result, "%d", value);
}
int intlen(int value) {
    return snprintf(NULL, 0, "%d", value);
}
int ftoa(char *result, float value) {
    return sprintf(result, "%f", value);
}
int floatlen(float value) {
    return snprintf(NULL, 0, "%f", value);
}