<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>

<!DOCTYPE html>
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">

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

</head>

<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		int bbsID = 0;
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		String category = null;
		if (request.getParameter("category") != null) {
			category = (String) request.getParameter("category");
		}

		Bbs bbs = new BbsDAO().getBbs(bbsID, category);
	%>
	
	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark static-top">
		<div class="container">
			<a class="navbar-brand" href="#">LOL Ledder</a>
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
					<li class="nav-item"><a class="nav-link" href="#">내 전적</a></li>
					<li class="nav-item"><a class="nav-link" href="#">랭킹</a></li>
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

	<div class="container">
		<div class="row">
			<table class="table" style="text-align: left;">
				<thead>
					<tr>
						<th colspan="2"
							style="text-align: left; font-size: large; padding-left: 20px;"><%=bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\n", "<br>")%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 10%; text-align: center;">작성자</td>
						<td><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<td style="text-align: center;">작성일자</td>
						<td><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시 "
					+ bbs.getBbsDate().substring(14, 16) + "분"%>
					</tr>
					<tr>
						<td style="text-align: center;">내용</td>
						<td style="min-height: 200px; text-align: left;"><%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\n", "<br>")%></td>
					</tr>
				</tbody>
			</table>
			<a style="margin-right: 5px" href="bbs.jsp?category=<%=category %>" class="btn btn-primary">목록</a>
			<%
				if (userID != null && userID.equals(bbs.getUserID())) {
			%>
			<a style="margin-right: 5px" href="bbs_update.jsp?bbsID=<%=bbsID%>&category=<%=category %>" class="btn btn-primary">수정</a>
			<a onClick="return confirm('정말로 삭제하시겠습니까?')"
				href="bbs_deleteAction.jsp?bbsID=<%=bbsID%>&category=<%=category %>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
		</div>
	</div>

	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>

</body>
</html>