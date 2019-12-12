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
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'bbs_login.jsp'");
			script.println("</script>");
		}
		String category = null;
		if (request.getParameter("category") != null) {
			category = (String) request.getParameter("category");
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

		Bbs bbs = new BbsDAO().getBbs(bbsID, category);
		if (!userID.equals(bbs.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
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
					<li class="nav-item"><a class="nav-link"
						href="index.jsp">전적 검색
					</a></li>
					<li class="nav-item"><a class="nav-link" href="#">내 전적</a></li>
					<li class="nav-item"><a class="nav-link" href="#">랭킹</a></li>
					<li class="nav-item active"><a class="nav-link" href="bbs.jsp">커뮤니티</a>
					</li>
				</ul>
			</div>

			<a class="btn btn-primary" href="bbs_deleteAction.jsp">로그아웃</a>

		</div>
	</nav>
	<div class="container">
		<form method="post" action="bbs_updateAction.jsp?bbsID=<%=bbsID%>&category=<%=category%>">
			<div style="text-align: center;">
				<div
					style="text-align: left; padding-left: 10px; margin-bottom: 20px; font-weight: bold; font-size: large;">게시판
					글 수정</div>
				<div style="margin: 10px">
					<input type="text" class="form-control" placeholder="글 제목"
						name="bbsTitle" maxlength="50" value=<%= bbs.getBbsTitle() %>>
				</div>
				<div style="margin: 10px">
					<textarea class="form-control" placeholder="글 내용" name="bbsContent"
						maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea>
				</div>
			</div>
			<input type="submit" class="btn btn-primary pull-right" value="수정">
		</form>
	</div>

	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>

</body>
</html>