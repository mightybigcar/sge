/*___INFO__MARK_BEGIN__*/
/*************************************************************************
 *
 *  The Contents of this file are made available subject to the terms of
 *  the Sun Industry Standards Source License Version 1.2
 *
 *  Sun Microsystems Inc., March, 2001
 *
 *
 *  Sun Industry Standards Source License Version 1.2
 *  =================================================
 *  The contents of this file are subject to the Sun Industry Standards
 *  Source License Version 1.2 (the "License"); You may not use this file
 *  except in compliance with the License. You may obtain a copy of the
 *  License at http://gridengine.sunsource.net/Gridengine_SISSL_license.html
 *
 *  Software provided under this License is provided on an "AS IS" basis,
 *  WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
 *  WITHOUT LIMITATION, WARRANTIES THAT THE SOFTWARE IS FREE OF DEFECTS,
 *  MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE, OR NON-INFRINGING.
 *  See the License for the specific provisions governing your rights and
 *  obligations concerning the Software.
 *
 *   The Initial Developer of the Original Code is: Sun Microsystems, Inc.
 *
 *   Copyright: 2001 by Sun Microsystems, Inc.
 *
 *   All Rights Reserved.
 *
 ************************************************************************/
/*___INFO__MARK_END__*/                                   

#include <stdio.h>
#include <stdlib.h>

#include "cull.h"

#include "sge_stdlib.h"
#include "sge_string.h"
#include "sge_dstring.h"
#include "sge_unistd.h"

#include "sge_all_listsL.h"

#include "sge_answer.h"

#include "spool/sge_spooling_utilities.h"

int main(int argc, char *argv[])
{
   lListElem *queue, *copy;
   lList *queue_list;
   lList *answer_list = NULL;
   const lDescr *descr;
   spooling_field *fields;
   const char *filepath;

   dstring queue_str = DSTRING_INIT;
   dstring copy_str  = DSTRING_INIT;

   int i;
   int width;
   char format[100];

   lInit(nmv);

   queue = queue_create_template();
   lSetString(queue, QU_terminate_method, "/tmp/myterminate_method.sh");
   lAddSubStr(queue, CE_name, "foo", QU_suspend_thresholds, CE_Type);
   lAddSubStr(queue, CE_name, "bar", QU_suspend_thresholds, CE_Type);
   copy  = lCreateElem(QU_Type);

   queue_list = lCreateList("queue_list", QU_Type);
   lAppendElem(queue_list, queue);
   lAppendElem(queue_list, copy);

   descr = lGetElemDescr(queue);
   
   fields = spool_get_fields_to_spool(&answer_list, QU_Type, &spool_config_instr);
   printf("\nthe following fields are spooled:");
   for(i = 0; fields[i].nm != NoName; i++) {
      printf(" %s", lNm2Str(fields[i].nm));
   }
   printf("\n");

   spool_flatfile_align_object(&answer_list, fields);
   width = fields[0].width;
   printf("alignment for attribute names is %d\n", width);

   spool_flatfile_align_list(&answer_list, queue_list, fields);
   printf("field widths for list output is as follows:\n");
   
   sprintf(format, "%%%ds: %%d\n", width);

   for(i = 0; fields[i].nm != NoName; i++) {
      printf(format, lNm2Str(fields[i].nm), fields[i].width);
   }

   filepath = spool_flatfile_write_object(&answer_list, queue,
                                          NULL,
                                          &spool_flatfile_instr_config,
                                          SP_DEST_STDOUT, SP_FORM_ASCII, NULL);
   if(filepath != NULL) {
      printf("\ndata successfully written to stdout\n");
      FREE(filepath);
   } else {
      answer_list_print_err_warn(&answer_list, NULL, NULL);
   }
                               
   printf("\n");

   filepath = spool_flatfile_write_object(&answer_list, queue,
                               NULL,
                               &spool_flatfile_instr_config,
                               SP_DEST_TMP, SP_FORM_ASCII, NULL);
   if(filepath != NULL) {
      printf("temporary file %s successfully written\n", filepath);
      sge_unlink(NULL, filepath);
      FREE(filepath);
   } else {
      answer_list_print_err_warn(&answer_list, NULL, NULL);
   }
                               
   filepath = spool_flatfile_write_object(&answer_list, queue,
                               NULL,
                               &spool_flatfile_instr_config,
                               SP_DEST_SPOOL, SP_FORM_ASCII, 
                               "test_sge_spooling_flatfile.dat");
   if(filepath != NULL) {
      lListElem *reread_queue;

      printf("spool file %s successfully written\n", filepath);

      /* reread queue from file */
      reread_queue = spool_flatfile_read_object(&answer_list, QU_Type, NULL, NULL,
                                                &spool_flatfile_instr_config, 
                                                SP_FORM_ASCII, NULL, 
                                                "test_sge_spooling_flatfile.dat");
     
      if(reread_queue == NULL) {
         answer_list_print_err_warn(&answer_list, NULL, NULL);
      } else {
         lWriteElemTo(reread_queue, stdout);
         reread_queue = lFreeElem(reread_queue);
      }
     
      sge_unlink(NULL, filepath);
      FREE(filepath);
   } else {
      answer_list_print_err_warn(&answer_list, NULL, NULL);
   }
   
   filepath = spool_flatfile_write_list(&answer_list, queue_list,
                                        NULL,
                                        &spool_flatfile_instr_config_list,
                                        SP_DEST_STDOUT, SP_FORM_ASCII, 
                                        NULL);
   if(filepath != NULL) {
      printf("\ndata successfully written to stdout\n");
      FREE(filepath);
   } else {
      answer_list_print_err_warn(&answer_list, NULL, NULL);
   }
   
   filepath = spool_flatfile_write_list(&answer_list, queue_list,
                                        NULL,
                                        &spool_flatfile_instr_config_list,
                                        SP_DEST_SPOOL, SP_FORM_ASCII, 
                                        "test_sge_spooling_flatfile.dat");
   if(filepath != NULL) {
      lList *reread_list;

      printf("spool file %s successfully written\n", filepath);

      reread_list = spool_flatfile_read_list(&answer_list, QU_Type, NULL, NULL, &spool_flatfile_instr_config_list, SP_FORM_ASCII, NULL, "test_sge_spooling_flatfile.dat");
      if (reread_list == NULL) {
         answer_list_print_err_warn(&answer_list, NULL, NULL);
      } else {
         lWriteListTo(reread_list, stdout);
         reread_list = lFreeList(reread_list);
      }
/*       sge_unlink(NULL, filepath); */
      FREE(filepath);
   } else {
      answer_list_print_err_warn(&answer_list, NULL, NULL);
   }

   /* test reading object */
   /* test nonexisting filename */
   
   /* test behaviour with NULL-pointer passed */
   printf("\n\ntesting error handling, the next calls have to fail\n");
   spool_flatfile_align_object(&answer_list, NULL);
   spool_flatfile_align_list(&answer_list, NULL, fields);
   spool_flatfile_align_list(&answer_list, queue_list, NULL);
   answer_list_print_err_warn(&answer_list, NULL, NULL);

   /* cleanup */
   queue_list = lFreeList(queue_list);

   sge_dstring_free(&queue_str);
   sge_dstring_free(&copy_str);

   fields = spool_free_spooling_fields(fields);

   fprintf(stdout, "file handle stdout still alive\n");
   fprintf(stderr, "file handle stderr still alive\n");

   return EXIT_SUCCESS;
}