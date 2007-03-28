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
/**
 *  Generated from javadescriptor.jsp
 *  !!! DO NOT EDIT THIS FILE !!!
 */
<%
  com.sun.grid.cull.CullDefinition cullDef = (com.sun.grid.cull.CullDefinition)params.get("cullDef");
  com.sun.grid.cull.JavaHelper jh = (com.sun.grid.cull.JavaHelper)params.get("javaHelper");
  com.sun.grid.cull.CullObject cullObj = (com.sun.grid.cull.CullObject)params.get("cullObj");
  com.sun.grid.cull.CullAttr   attr = null;
  
  com.sun.grid.cull.CullObject parent = cullObj.getParentObject();
  
  class DescriptorGenerator {
     
     
  }
%>
package <%=jh.getPackageName()%>;

import com.sun.grid.jgdi.configuration.*;
import com.sun.grid.jgdi.CullConstants;

/**
 *  Java descriptor of the cull object <%=cullObj.getName()%>
 *  defined in <%=jh.getSource(cullObj).getName()%>
 */
public class <%=jh.getClassName(cullObj)%>Descriptor extends <%

   if(parent != null) {
     %> <%=jh.getClassName(parent)%>Descriptor <%
   } else {
     %> GEObjectDescriptor <%
   }       
%>{


   public <%=jh.getClassName(cullObj)%>Descriptor() {
      this(<%=jh.getClassName(cullObj)%>.class, <% 
      
       if(parent != null ) {
          %>"<%=cullObj.getName()%>" <%
       } else {
          %>"<%=cullObj.getName()%>" <%
       }
       
   %>);
      setImplClass(<%=jh.getClassName(cullObj)%>Impl.class);
   }
      
   protected <%=jh.getClassName(cullObj)%>Descriptor(Class type, String name) {
      super(type, name);
<%
  if(jh.getClassName(cullObj).equals("User")) {
%>
      // exclude some configurable attributes for User
      PropertyDescriptor pd = this.getPropertyByCullFieldName(CullConstants.UP_acl);
      pd.setConfigurable(false);
      pd = this.getPropertyByCullFieldName(CullConstants.UP_xacl);
      pd.setConfigurable(false);
<%
  } else if (jh.getClassName(cullObj).equals("Project")) {
%>
      // exclude some configurable attributes for Project
      PropertyDescriptor pd = this.getPropertyByCullFieldName(CullConstants.UP_delete_time);
      pd.setConfigurable(false);
      pd = this.getPropertyByCullFieldName(CullConstants.UP_default_project);
      pd.setConfigurable(false);
<%
  }
%>      
<% 
  if(cullObj.getOwnAttrCount() > 0 ) {
%>     
      PropertyDescriptor propDescr = null;
<%
  }
  for(int i = 0; i < cullObj.getOwnAttrCount(); i++ ) {

   attr = cullObj.getOwnAttr(i);
   
   if(attr.isHidden() ) {
      continue;
   }
      
   String attrType = jh.getFullClassName(attr.getType());
   String attrName = jh.getAttrName(attr);

   String gsname =  Character.toUpperCase( attrName.charAt(0) ) +
                   attrName.substring(1);

   com.sun.grid.cull.CullObject subobj = null;
   
   if( attr instanceof com.sun.grid.cull.CullMapListAttr ) {
       com.sun.grid.cull.CullMapListAttr mapAttr = (com.sun.grid.cull.CullMapListAttr)attr;
       
       
       com.sun.grid.cull.CullAttr keyAttr = mapAttr.getKeyAttr();
       com.sun.grid.cull.CullAttr valueAttr = mapAttr.getValueAttr();
       
       subobj = cullDef.getCullObject(valueAttr.getType());
       
       String keyClass = jh.getClassNameWithSuffix(keyAttr.getType());
       String valueClass = jh.getClassNameWithSuffix(valueAttr.getType());
       
       if( attrName.endsWith("List") ) {          
          attrName  = attrName.substring(0, attrName.length() - 4 );
          gsname =  Character.toUpperCase( attrName.charAt(0) ) +
                   attrName.substring(1);
          
       }
%>       
      // keyAttr = <%= keyAttr.getName() %> (type = <%=keyAttr.getType()%>)
      // valueAttr = <%= valueAttr.getName() %> (type = <%=valueAttr.getType()%>)
      propDescr = addMapList("<%=attrName%>", <%=valueClass%>, "<%=attr.getType()%>", <%=keyClass%>, "<%=valueAttr.getType()%>",
             CullConstants.<%=attr.getName()%>, CullConstants.<%=mapAttr.getKeyAttr().getName()%>, CullConstants.<%=mapAttr.getValueAttr().getName()%>,
             <%=attr.getDefault() == null ? "null" : "\"" + attr.getDefault() + "\"" %>,<%=attr.isReadOnly()%>, <%=attr.isConfigurable()%> ); <%
   } else if( attr instanceof com.sun.grid.cull.CullMapAttr ) {
       
       com.sun.grid.cull.CullMapAttr mapAttr = (com.sun.grid.cull.CullMapAttr)attr;
       
       com.sun.grid.cull.CullAttr keyAttr = mapAttr.getKeyAttr();
       com.sun.grid.cull.CullAttr valueAttr = mapAttr.getValueAttr();

       subobj = cullDef.getCullObject(valueAttr.getType());
       
       String keyClass = jh.getClassNameWithSuffix(keyAttr.getType());
       String valueClass = jh.getClassNameWithSuffix(valueAttr.getType());
       
       if( attrName.endsWith("List") ) {          
          attrName  = attrName.substring(0, attrName.length() - 4 );
          gsname =  Character.toUpperCase( attrName.charAt(0) ) +
                   attrName.substring(1);
          
       }
       
%>       
      // keyAttr = <%= keyAttr.getName() %> (type = <%=keyAttr.getType()%>)
      // valueAttr = <%= valueAttr.getName() %> (type = <%=valueAttr.getType()%>)
      propDescr = addMap("<%=attrName%>", <%=valueClass%>, "<%=attr.getType()%>", <%=keyClass%>,
             CullConstants.<%=attr.getName()%>, CullConstants.<%=mapAttr.getKeyAttr().getName()%>, CullConstants.<%=mapAttr.getValueAttr().getName()%>,
             <%=attr.getDefault() == null ? "null" : "\"" + attr.getDefault() + "\"" %>, <%=attr.isReadOnly()%>, <%=attr.isConfigurable()%> ); <%
               
   } else if( attr instanceof com.sun.grid.cull.CullListAttr ) {
      subobj = cullDef.getCullObject(attr.getType());
       if( attrName.endsWith("List") ) {          
          attrName  = attrName.substring(0, attrName.length() - 4 );
          gsname =  Character.toUpperCase( attrName.charAt(0) ) +
                   attrName.substring(1);
          
       }
%>
      propDescr = addList("<%=attrName%>", <%=jh.getClassNameWithSuffix(attr.getType())%>, "<%=attr.getType()%>", CullConstants.<%=attr.getName()%>, true, <%=attr.isReadOnly()%>, <%=attr.isConfigurable()%> );
<% 
   
   } else { 
      subobj = cullDef.getCullObject(attr.getType());
%>
      propDescr = addSimple("<%=attrName%>", <%=jh.getClassNameWithSuffix(attr.getType())%>, "<%=attr.getType()%>", CullConstants.<%=attr.getName()%>, <%=attr.isPrimaryKey()%>, <%=attr.isReadOnly()%>, <%=attr.isConfigurable()%>); 
<%
   } // end of if

   if(subobj != null) {
      if(subobj.getType() == com.sun.grid.cull.CullObject.TYPE_PRIMITIVE) { 
         %>
         propDescr.setHasCullWrapper(true);
         propDescr.setCullContentField(CullConstants.<%=subobj.getContentAttrName()%>);
         <%         
      } else if (subobj.getType() == com.sun.grid.cull.CullObject.TYPE_MAPPED ) {
         %>
         propDescr.setHasCullWrapper(true);
         propDescr.setCullContentField(-1);
         <%
      }
   }

  } // end of for
%>
   }
   
   public void validate(Object obj) throws InvalidObjectException {
   
      if( !(obj instanceof <%=jh.getClassName(cullObj)%>) ) {
         throw new InvalidObjectException(obj, "obj is not an instanceof <%=jh.getClassName(cullObj)%>");
      }
      
<%
   if(cullObj.getAttrCount() > 0 ) {
%>  
      <%=jh.getClassName(cullObj)%> cullObj = (<%=jh.getClassName(cullObj)%>)obj;
      
      InvalidObjectException exc = null;
      
<%
  for(int i = 0; i < cullObj.getPrimaryKeyCount(); i++ ) {

   attr = cullObj.getPrimaryKeyAttr(i);
   
   String attrType = jh.getFullClassName(attr.getType());
   String attrName = jh.getAttrName(attr);

   String gsname =  Character.toUpperCase( attrName.charAt(0) ) +
                   attrName.substring(1);

%>   
       if(!cullObj.isSet<%=gsname%>()) {
          if(exc == null) {
             exc = new InvalidObjectException(obj, "Primary key fields are not set");
          }
          exc.addPropertyError("<%=attrName%>", "primary key field is required");
       }
<%
  } // end of for
%>  
       if(exc != null) {
           throw exc;
       }
<%  
   } // end of if attrCount > 0
  if (parent != null) {
%>     
       super.validate(obj);
<%   
  }
%>
   }
}
