
#pragma once

#define _SCREEN_PREFIX "screen_"

#define SCREEN(name) \
  _Pragma("GCC push") \
  _Pragma("GCC diagnostic ignored \"-Wattributes\"") \
  __attribute__((annotate(_SCREEN_PREFIX #name))) \
  _Pragma("GCC pop")

#define SCREEN_START(name) \
  _Pragma("GCC push") \
  _Pragma("GCC diagnostic ignored \"-Wattributes\"") \
  char __screen_ ## name ## _start  \
    __attribute__((annotate(_SCREEN_PREFIX #name "_start"))); \
  (void) __screen_ ## name ## _start; \
  _Pragma("GCC pop")
  

#define SCREEN_END(name) \
  _Pragma("GCC push") \
  _Pragma("GCC diagnostic ignored \"-Wattributes\"") \
  char __screen_ ## name ## _end \
  __attribute__((annotate(_SCREEN_PREFIX #name "_end"))); \
  (void) __screen_ ## name ## _end; \
  _Pragma("GCC pop")
