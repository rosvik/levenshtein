#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "levenshtein.h"

char * 
filecontents(char *fname) {

  char * buffer = 0;
  long length = 0L;

  FILE * f = fopen (fname, "rb");

  if (f) {
    fseek (f, 0, SEEK_END);
    length = ftell (f);
    fseek (f, 0, SEEK_SET);
    buffer = malloc (length);
    if (buffer)
    {
      fread (buffer, 1, length, f);
    }
    fclose (f);
  }
  return buffer;
}

// CLI.
int
main(int argc, char **argv) {
  char *a = argv[1];
  char *b = argv[2];
  char *c = argv[3];

  if (argc == 2) {
    if (!strcmp(a, "-v") || !strcmp(a, "--version")) {
      printf("%s", "0.1.1-rosvik\n");
      return 0;
    }

    if (!strcmp(a, "-h") || !strcmp(a, "--help")) {
      printf("%s", "\n");
      printf("%s", "  Usage: levenshtein <files...>\n");
      printf("%s", "\n");
      printf("%s", "  Levenshtein algorithm CLI\n");
      printf("%s", "\n");
      printf("%s", "  Options:\n");
      printf("%s", "\n");
      printf("%s", "    -h, --help           output usage information\n");
      printf("%s", "    -v, --version        output version number\n");
      printf("%s", "    -s, --string         give strings as input\n");
      printf("%s", "\n");
      printf("%s", "  Usage:\n");
      printf("%s", "\n");
      printf("%s", "  # output distance\n");
      printf("%s", "  $ levenshtein file1.txt file2.txt\n");
      printf("%s", "  # 312\n");
      printf("%s", "\n");
      return 0;
    }
  }

  if (argc < 3) {
    fprintf(stderr, "\033[31mLevenshtein expects at least two arguments\033[0m\n");
    return 1;
  }

  // String compare
  if (!strcmp(a, "-s") || !strcmp(a, "--string")) {
    if (argc != 4) {
      fprintf(stderr, "\033[31mExpecting two strings as arguments\033[0m\n");
      return 1;
    }

    printf("%zu\n", levenshtein(b, c));
    return 0;
  }

  // File compare
  char * file_1 = filecontents(a);
  if(!file_1) {
    fprintf(stderr, "\033[31mError reading %s\033[0m\n", a);
    return 1;
  }

  char * file_2 = filecontents(b);
  if(!file_2) {
    fprintf(stderr, "\033[31mError reading %s\033[0m\n", b);
    return 1;
  }

  printf("%zu\n", levenshtein(file_1, file_2));
  return 0;
}
