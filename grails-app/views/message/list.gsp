<%@ page import="tower.Message" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'message.label', default: 'Message')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-message" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-message" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="params" title="${message(code: 'message.params.label', default: 'Params')}" />
					
						<g:sortableColumn property="dateCreated" title="${message(code: 'message.dateCreated.label', default: 'Date Created')}" />
					
						<g:sortableColumn property="host" title="${message(code: 'message.host.label', default: 'Host')}" />
					
						<g:sortableColumn property="lastUpdated" title="${message(code: 'message.lastUpdated.label', default: 'Last Updated')}" />
					
						<g:sortableColumn property="requestSent" title="${message(code: 'message.requestSent.label', default: 'Request Sent')}" />
					
						<g:sortableColumn property="responseReceived" title="${message(code: 'message.responseReceived.label', default: 'Response Received')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${messageInstanceList}" status="i" var="messageInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${messageInstance.id}">${fieldValue(bean: messageInstance, field: "params")}</g:link></td>
					
						<td><g:formatDate date="${messageInstance.dateCreated}" /></td>
					
						<td>${fieldValue(bean: messageInstance, field: "host")}</td>
					
						<td><g:formatDate date="${messageInstance.lastUpdated}" /></td>
					
						<td>${fieldValue(bean: messageInstance, field: "requestSent")}</td>
					
						<td>${fieldValue(bean: messageInstance, field: "responseReceived")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${messageInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
