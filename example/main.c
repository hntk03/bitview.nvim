#include <stdio.h>

int main(void) {
  const int a = 0x62;
  const int b = 0xEA03;

  int sum = a + b;
  printf("%d\n", sum);

  return 0;
}
