<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
<title>Gallery</title>
<style type="text/css">
	#uploadManager {
		height: 300px;
		width: 500px;
	}
	#uploadQueue {
		height: 200px;
		overflow: scroll;
	}
	#uploadQueue li {
		float: left;
	}
	#uploadManager form :last-child {
		float: right;
	}
	.items li {
		height: <c:out value="${settings.thumbHeight + 30}"/>px;
		width: <c:out value="${settings.thumbWidth + 30}"/>px;
		display: inline-block;
		vertical-align: top;
	}
	.items img {
			display: block;
			margin-left: auto;
			margin-right: auto;
	}
	.items li > a:nth-child(3) {
		display: block;
		text-align: center;
	}
	.tools {
		position: relative;
		bottom: 15px;
		display: none;
	}
	.tools a:nth-child(1){
		float: left;
	}
	.tools a:nth-child(2){
		float: left;
	}
	.tools a:nth-child(3){
		float: right;
	}
</style>
<script type="text/javascript">
	require(["dijit/form/Form",
	         "dijit/form/Button",
	         "dijit/form/DropDownButton",
	         "dijit/Dialog",
	         "dijit/TooltipDialog",
	         "dijit/form/TextBox",
	         "dijit/form/CheckBox",
	         "dojox/form/Uploader",
	         "dojox/form/uploader/FileList"]);
	
	require(["dojo/ready", 
	         "dojo/query",
	         "dojo/dom-style",
	         "dojo/_base/xhr",
	         "dojo/dom-attr",
	         "pgGallery/Message",
	         "dojo/dom-construct"],
			function(ready, _query,_style, _xhr, _attr, _mesg, _dom){
				ready(function(){
					var query = _query;
					query("#deleteAlbum").on("click", function(e){
						e.preventDefault();
						var xhr = _xhr;
						var attr = _attr;
						var target = e.currentTarget;
						
						xhr.del({
							url: target.dataset["href"],
							handleAs: "json",
							load: function(data){
								var mesg = _mesg;
								if(data.status == "success"){
									window.location = "<c:url value="/gallery"/>";	
								} else {
									mesg.error("Unable to delete album " + data.message);	
								}
							},
							error: function(error){
								var mesg = _mesg;
								mesg.error("Unable to delete album " + error);
							}
						});
					});
					query(".items li").connect("onmouseenter", function(e){
						var query = _query;
						query(".tools", e.currentTarget).forEach(function(node, index, arr){
							var style = _style;
							style.set(node, "display", "block");
						});
					});
					query(".items li").connect("onmouseleave", function(e){
						var query = _query;
						query(".tools", e.currentTarget).forEach(function(node, index, arr){
							var style = _style;
							style.set(node, "display", "none");
						});
					});
					query(".tools a:nth-child(odd)").on("click", function(e){
						e.preventDefault();
						var xhr = _xhr;
						var attr = _attr;
						var target = e.currentTarget;
						xhr.post({
							url: attr.get(target, "href"),
			                handleAs: "json",
			                load: function(data) {
			                	var u = target;
			                	var query = _query;
			                	if(data.status == "success"){
			                		query("> a img", u.parentNode.parentNode).forEach(function(node, index, arr){
			                			var attr = _attr;
			                			attr.set(node, "src",  attr.get(node, "src") + "?dummy=" + Math.floor(Math.random()*100000));
			        				});
			                	}
			                },
			                error: function(error) {
			                	var mesg = _mesg;
			                	mesg.error("Unable to rotate image " + error);
			                }
						});
					});
					query(".tools a:nth-child(2)").on("click", function(e){
						e.preventDefault();
						var xhr = _xhr;
						var attr = _attr;
						var target = e.currentTarget;
						xhr.del({
							url: attr.get(target, "href"),
			                handleAs: "json",
			                load: function(data) {
			                	var u = target;
			                	var query = _query;
			                	var dom = _dom;
			                	if(data.status == "success"){
			                		dom.destroy(u.parentNode.parentNode);
			                	}
			                },
			                error: function(error) {
			                	var mesg = _mesg;
			                	mesg.error("Unable to delete image " + error);
			                }
						});
					});
				});
			}
	);
	
	require(["pgGallery/UploadItems"], function(m){
		m.button("uploadDialog", "uploadManager");
		m.manage("item", "uploadQueue");
	});
</script>
</head>
<body>
	<div class="content">
		<h2>
			Album:
			<c:out default="Root" value="${currentAlbum.name}" />
		</h2>
		<ul class="breadcrumbs">
			<li>Path:</li>
			<li><a href="<c:url value="/gallery"/>">Root</a></li>
			<c:forEach var="crumb" items="${breadcrumbs}">
				<li>&gt;</li>
				<li><a href="<c:url value="/gallery/album/${crumb.id}"/>"><c:out value="${crumb.name}" /></a></li>
			</c:forEach>
			<sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
			<li>
				<div data-dojo-type="dijit.form.DropDownButton">
					<span>New Album</span>
					<div data-dojo-type="dijit.TooltipDialog">
						<form data-dojo-type="dijit.form.Form" action="<c:url value="/gallery/album/create"/>" method="POST">
							<label for="name"> Name:</label><input data-dojo-type="dijit.form.TextBox" id="name" name="name">
							<input id="isPublic" name="isPublic" data-dojo-type="dijit.form.CheckBox" value="true" /><label for="isPublic">Public?</label>
							<input data-dojo-type="dijit.form.TextBox" type="hidden" name="parentId" value="<c:out value="${currentAlbum.id}"/>" />
							<button data-dojo-type="dijit.form.Button" type="submit">Create</button>
						</form>
					</div>
				</div>
			</li>
			<li>
				<button id="uploadDialog" data-dojo-type="dijit.form.Button" type="submit">Upload Items</button>
				<div id="uploadManager" data-dojo-type="dijit.Dialog" title="Upload Manager">
					<form data-dojo-type="dijit.form.Form" enctype="multipart/form-data" action="<c:url value="/gallery/item/upload"/>" method="POST">
							<input id="item" name="item" multiple="multiple" type="file" data-dojo-type="dojox.form.Uploader" label="Upload New Photos" />
							<input data-dojo-type="dijit.form.TextBox" type="hidden" name="parentId" value="<c:out value="${currentAlbum.id}"/>" />
							<ul id="uploadQueue">
								
							</ul>
							<button data-dojo-type="dijit.form.Button" type="submit">Upload</button>
					</form>
				</div>
			</li>
			<li>
				<c:if test="${! empty currentAlbum}">
						<button id="deleteAlbum"
							data-href="<c:out value="/gallery/album/${currentAlbum.id}"/>"
							data-dojo-type="dijit.form.Button" 
							data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconDelete', showLabel: false" 
							type="button">Delete Album</button>
				</c:if>
			</li>
			</sec:authorize>
		</ul>
		<br />
		<ul class="items">
			<c:forEach var="a" items="${childAlbums}">
				<li>
					<a href="<c:url value="/gallery/album/${a.id}"/>">
						<img src="<c:url value="/gallery/album/${a.id}/thumb"/>" />
					</a><br />
					<a href="<c:url value="/gallery/album/${a.id}"/>">
						<c:out value="${a.name}" />
					</a>
				</li>
			</c:forEach>
			<c:forEach var="i" items="${childItems}">
				<li>
					<a href="<c:url value="/gallery/item/${i.id}"/>">
						<img src="<c:url value="/gallery/item/${i.id}/thumb"/>" />
					</a>
					<sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
					<c:if test="${i.duplicate == true}">
							<img src="<c:url value="/img/duplicate.png"/>" alt="Duplicate Item"/>
					</c:if>
					<span class="tools">
						<a href="<c:url value="/gallery/item/${i.id}/rotate/left"/>">
							<img src="<c:url value="/img/rotate_left_small.png"/>" alt="Rotate Left"/>
						</a>
						<a href="<c:url value="/gallery/item/${i.id}"/>">
							<img src="<c:url value="/img/delete.png"/>" alt="Delete"/>
						</a>
						<a href="<c:url value="/gallery/item/${i.id}/rotate/right"/>">
							<img src="<c:url value="/img/rotate_right_small.png"/>" alt="Rotate Right"/>
						</a>
					</span>
					</sec:authorize>
				</li>
			</c:forEach>
		</ul>
	</div>
</body>
</html>