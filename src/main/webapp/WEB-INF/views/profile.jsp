<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
	<head>
		<title>Profile Page</title>
		<script type="text/javascript">
		require(["dijit/form/Form",
		         "dijit/form/Button",
		         "dijit/form/ValidationTextBox"
		         ]);
		require(["pgGallery/Focus"],function(f){f.focus("currentPassword")});
		</script>
		<style>
			.content p {
				margin: 2px;
				padding-bottom: 5px;
			}
		</style>
	</head>
	<body>
		<div class="content">
			<p>Logged in as: <c:out value="${username}" /></p>
			
			<h2>Change Your Password</h2>
			<form data-dojo-type="dijit.form.Form" id="changePassForm" data-action="<c:url value="/profile" /> " data-method="POST">
	            <table>
	                <tr>
	                    <td>
	                        <label for="username">Current Password:</label>
	                    </td>
	                    <td>
	                        <input type="password" id="currentPassword" name="currentPassword" required="required" data-dojo-type="dijit.form.ValidationTextBox"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td>
	                        <label for="password">New Password:</label>
	                    </td>
	                    <td>
	                         <input type="password" name="newPassword" required="required" data-dojo-type="dijit.form.ValidationTextBox"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td>
	                        <label for="retypePassword">Retype Password:</label>
	                    </td>
	                    <td>
	                         <input type="password" id="retypePassword" name="retypePassword" required="required" data-dojo-type="dijit.form.ValidationTextBox"/>
	                    </td>
	                </tr>
	                <tr>
	                	<td><button data-dojo-type="dijit.form.Button" type="submit">Change Password</button></td>
	                </tr>
	            </table>
        	</form>     
		</div>
	</body>
</html>