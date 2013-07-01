#ifndef EXTERN_H
#define EXTERN_H

#include "hmap.h"
#include "squeue.h"

extern struct hmap *wk_table;
extern struct hmap *sym_table;
extern struct squeue *undeclared_vars;
extern unsigned mem_position;
extern unsigned current_line;
extern unsigned current_context;
extern bool found_error;


#endif
