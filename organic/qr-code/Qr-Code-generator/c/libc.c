

#include <stddef.h>
size_t strlen(const char* s) {
  const char *p = s;
  while (*p) p++;
  return p - s;
}
void *memset(void *s, int c, size_t n) {
  char *p = s;
  while (n--) *p++ = c;
  return s;
}
char *strchr(const char *p, int c) {
  while(*p) if (*p++ == c) return (char *)p;
  return 0;
}
void *memchr(const void *s, int c, size_t n) {
  const char *p = s;
  while(n--) if (*p++ == c) return (void *)p;
  return 0;
}
void* memcpy(void *dst, const void *src, size_t n) {
  char *p = dst;
  const char *s = src;
  while (n--) *p++ = *s++;
  return dst;
}
void* memmove(void *dst, const void *src, size_t n) {
  char *d = dst;
  const char *s = src;
  if (d <= s) {
    while (n--) *d++ = *s++;
  } else {
    s += n;
    d += n;
    while (n--) *d-- = *s--;
  }
  return dst;
}
int memcmp(const void *s1, const void *s2, size_t n) {
  for(size_t i = 0; i < n; i++) {
    const unsigned char* l = s1;
    const unsigned char* r = s2;
    if (l[i] < r[i]) return -1;
    if (l[i] > r[i]) return 1;
  }
  return 0;
}
int abs(int n) { return n < 0 ? -n : n; }
long labs(long n) { return n < 0 ? -n : n; }

