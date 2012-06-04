 <%--
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 *
--%> 
<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.openmrs.Patient" %>

<script type="text/javascript">
	
	PATIENTSEARCHRESULT = {
		oldBackgroundColor: "",
		
		/** Click to view patient info */
		visit: function(patientId){			
			window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + patientId;
		},
		
		/** Edit a patient */
		editPatient: function(patientId){
			window.location.href = openmrsContextPath + "/module/registration/editPatient.form?patientId=" + patientId;
		},
		
		reprint: function(patientId){
			window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + patientId + "&reprint=true";
		}
	};
	
	jQuery(document).ready(function(){
	
		// hover rows
		jQuery(".patientSearchRow").hover(
			function(event){					
				obj = event.target;
				while(obj.tagName!="TR"){
					obj = obj.parentNode;
				}
				PATIENTSEARCHRESULT.oldBackgroundColor = jQuery(obj).css("background-color");
				jQuery(obj).css("background-color", "#00FF99");									
			}, 
			function(event){
				obj = event.target;
				while(obj.tagName!="TR"){
					obj = obj.parentNode;
				}
				jQuery(obj).css("background-color", PATIENTSEARCHRESULT.oldBackgroundColor);				
			}
		);
		
		// insert images
		jQuery(".editImage").each(function(index, value){
			jQuery(this).attr("src", openmrsContextPath + "/images/edit.gif");
		});		
	});
</script>

<c:choose>
	<c:when test="${not empty patients}" >		
	<table style="width:100%">
		<tr>
		<openmrs:hasPrivilege privilege="Edit Patients">
            <td><b>Edit</b></td>
        </openmrs:hasPrivilege>			
			<td><b>Identifier</b></td>
			<td><b>Name</b></td>
			<td><b>Age</b></td>
			<td><b>Gender</b></td>			
			<td><b>Birthdate</b></td>
			<td><b>Relative Name</b></td>
			<td><b>Last day of visit</b></td>
			<!-- June 4th 2012 - Thai Chuong removed Phone Number field to match requirement:
			 Feature: Search a patient on the basis of last day of visit
			 UC 7: Advance search of patient
			 -->
			<!-- <td><b>Phone number</b></td> -->
			<td><b>Reprint OPD slip</b></td>
		</tr>
		<c:forEach items="${patients}" var="patient" varStatus="varStatus">
			<tr class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow" } patientSearchRow'>
				<openmrs:hasPrivilege privilege="Edit Patients">
					<td onclick="PATIENTSEARCHRESULT.editPatient(${patient.patientId});">
						<center>
							<img class="editImage" title="Edit patient information"/>
						</center>
					</td>
				</openmrs:hasPrivilege>		
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">
					${patient.patientIdentifier.identifier}
				</td>
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">${patient.givenName} ${patient.middleName} ${patient.familyName}</td>
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<c:choose>
                		<c:when test="${patient.age == 0}">&lt 1</c:when>
                		<c:otherwise >${patient.age}</c:otherwise>
                	</c:choose>
                </td>
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">
					<c:choose>
                		<c:when test="${patient.gender eq 'M'}">
							<img src="${pageContext.request.contextPath}/images/male.gif"/>
						</c:when>
                		<c:otherwise><img src="${pageContext.request.contextPath}/images/female.gif"/></c:otherwise>
                	</c:choose>
				</td>                
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<openmrs:formatDate date="${patient.birthdate}"/>
                </td>
				<td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<%
						Patient patient = (Patient) pageContext.getAttribute("patient");
						Map<Integer, Map<Integer, String>> attributes = (Map<Integer, Map<Integer, String>>) pageContext.findAttribute("attributeMap");						
						Map<Integer, String> patientAttributes = (Map<Integer, String>) attributes.get(patient.getPatientId());						
						String relativeName = patientAttributes.get(8); 
						if(relativeName!=null)
							out.print(relativeName);
					%>
                </td>
                <td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});">
	                <openmrs:formatDate date="${lastVisitTime[patient.patientId]}"/>              	
                </td>
                <!-- June 4th 2012 - Thai Chuong removed Phone Number field to match requirement:
				 Feature: Search a patient on the basis of last day of visit
				 UC 7: Advance search of patient
				 -->
				<!-- <td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId});"> 
                	<%
/* 						String phoneNumber = patientAttributes.get(16);
						if(phoneNumber!=null)
							out.print(phoneNumber); */
					%>
                </td>  -->
                <td onclick="PATIENTSEARCHRESULT.reprint(${patient.patientId});"> 
                	Reprint OPD slip
                </td>
			</tr>
		</c:forEach>
	</table>
	</c:when>
	<c:otherwise>
	No Patient found.
	</c:otherwise>
</c:choose>