#include <stdio.h>
#include <string.h>

void revstr(char *s) {
  char *i1, *i2, *m;
  int len;

  len = strlen(s), i1 = s, i2 = i1+len-1, m = i1 + len/2;
  while (i1 < m) {
    char c;
    c = *i1;
    *i1++ = *i2;
    *i2-- = c;
  }
}

int main() {
  char s[512];
  gets(s);
  printf("s=%s\n", s);
  revstr(s);
  printf("rev s=%s\n", s);
}
