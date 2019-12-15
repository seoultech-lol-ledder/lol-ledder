<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	%>
	
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

	<title>과기대 랭킹</title>

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
					<li class="nav-item active"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
					<li class="nav-item"><a class="nav-link" href="bbs.jsp">커뮤니티</a>
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

      <div class="container-fluid">
      <!-- Breadcrumbs-->
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <a href="ranking.jsp">과기대 랭킹 보기</a>
          </li>
          <li class="breadcrumb-item active">
            <a href="total_ranking.jsp">전체 랭킹 보기</a>
            </li>
        </ol>
      </div>
	<jsp:include page="SearchRankingList.jsp" flush="false"/>
	<a class="btn btn-primary" style="float:right;" 
	href="refresh.jsp">갱 신</a>
	<!-- Bootstrap core JavaScript -->
	<script src="vendor/jquery/jquery.slim.min.js"></script>
	<script src="vendor/jquery/jquery.min.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>

</html>