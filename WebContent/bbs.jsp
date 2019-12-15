<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%>

<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	int pageNumber = 1;
	if (request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	String category = "free";
	if (request.getParameter("category") != null) {
		category = (String) request.getParameter("category");
	}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>jsp 게시판 웹사이트</title>

<!-- Bootstrap core CSS -->
<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom fonts for this template -->
<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
<link href="vendor/simple-line-icons/css/simple-line-icons.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic"
	rel="stylesheet" type="text/css">

<!-- Custom styles for this template -->
<link href="css/landing-page.min.css" rel="stylesheet">

<style type="text/css">
a {
	color: #000000
}

a:hover {
	color: #0000ff
}
</style>

</head>

<body>

	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark static-top">
		<div class="container">
			<a class="navbar-brand" href="index.jsp">LOL Ledder</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarResponsive" aria-controls="navbarResponsive"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item">
						<a class="nav-link" href="index.jsp">전적 검색</a>
					</li>
					<li class="nav-item"><a class="nav-link" href="myrecord.jsp">내 전적</a></li>
					<li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
					<li class="nav-item active"><a class="nav-link" href="bbs.jsp">커뮤니티</a>
					</li>
				</ul>
			</div>
			<%
				if (userID == null) {
			%>
			<a style="margin-right: 5px" class="btn btn-primary"
				href="bbs_login.jsp">로그인</a> <a class="btn btn-primary"
				href="bbs_join.jsp">회원가입</a>
			<%
				} else {
			%>
			<a class="btn btn-primary"
				href="bbs_logoutAction.jsp">로그아웃</a>
			<%
				}
			%>

		</div>
	</nav>


	<div>
		<div style="position: fixed; margin: 40px 0px 0px 20px;">
			<ul class="navbar-nav">
			<%
				if(category.equals("free")){
			%>
				<li><a href="bbs.jsp?category=free" class="btn btn-primary" style="width:200px;">자유</a></li>
			<%
				}else {
			%>
				<li><a href="bbs.jsp?category=free" class="btn btn-outline-primary" style="width:200px;">자유</a></li>
			<%
				}
			%>
			<%
				if(category.equals("humor")){
			%>
				<li style="margin-top: 5px;"><a href="bbs.jsp?category=humor" class="btn btn-primary"style="width:200px;">유머</a></li>
			<%
				}else {
			%>
				<li style="margin-top: 5px;"><a href="bbs.jsp?category=humor" class="btn btn-outline-primary" style="width:200px;">유머</a></li>
			<%
				}
			%>
			<%
				if(category.equals("knowhow")){
			%>
				<li style="margin-top: 5px;"><a href="bbs.jsp?category=knowhow" class="btn btn-primary" style="width:200px;">노하우</a></li>
			<%
				}else {
			%>
				<li style="margin-top: 5px;"><a href="bbs.jsp?category=knowhow" class="btn btn-outline-primary" style="width:200px;">노하우</a></li>
			<%
				}
			%>
			<%
				if(category.equals("civilwar")){
			%>
				<li style="margin-top: 5px;"><a href="bbs.jsp?category=civilwar" class="btn btn-primary" style="width:200px;">내전</a></li>
			<%
				}else {
			%>
				<li style="margin-top: 5px;"><a href="bbs.jsp?category=civilwar" class="btn btn-outline-primary" style="width:200px;">내전</a></li>
			<%
				}
			%>
			</ul>
		</div>
		<div class="container" style="text-align: middle;,margin: auto;">
			<div class="row">
				<table class="table table-hover" style="text-align: center">
					<thead>
						<tr>
							<th style="text-align: center">번호</th>
							<th style="text-align: center">제목</th>
							<th style="text-align: center">작성자</th>
							<th style="text-align: center">작성일</th>
						</tr>
					</thead>
					<tbody>
						<%
							BbsDAO bbsDAO = new BbsDAO();
							ArrayList<Bbs> list = bbsDAO.getList(pageNumber, category);
							for (int i = 0; i < list.size(); i++) {
						%>
						<tr>
							<td><%=list.get(i).getBbsID()%></td>
							<td><a href="bbs_view.jsp?category=<%=category %>&bbsID=<%=list.get(i).getBbsID()%>"><%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></a></td>
							<td><%=list.get(i).getUserID()%></td>
							<td><%=list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시 "
						+ list.get(i).getBbsDate().substring(14, 16) + "분"%></td>
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
				<%
					if (pageNumber != 1) {
				%>
				<a style="margin-right: 5px"
					href="bbs.jsp?category=<%=category %>&pageNumber=<%=pageNumber - 1%>"
					class="btn btn-outline-primary">이전</a>
				<%
					}
				%>
				<%
//					if (bbsDAO.nextPage(pageNumber + 1, category)) {
					if (bbsDAO.nextPage(pageNumber, category)) {

				%>
				<a style="margin-right: 5px"
					href="bbs.jsp?category=<%=category %>&pageNumber=<%=pageNumber + 1%>"
					class="btn btn-outline-primary">다음</a>
				<%
					}
				%>
				<a href="bbs_write.jsp?category=<%=category %>" class="btn btn-primary">글쓰기</a>
			</div>
		</div>.
	</div>

	<!-- Bootstrap core JavaScript -->
	<script src="vendor/jquery/jquery.slim.min.js"></script>
	<script src="vendor/jquery/jquery.min.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>