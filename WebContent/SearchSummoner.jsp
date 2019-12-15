<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%@ page import="Resources.LOLApiKey"%>
<%@ page import="Resources.SummonerDAO"%>

<%@ page import="net.rithms.riot.*"%>
<%@ page import="net.rithms.riot.api.ApiConfig"%>
<%@ page import="net.rithms.riot.api.RiotApi"%>
<%@ page import="net.rithms.riot.api.RiotApiException"%>
<%@ page import="net.rithms.riot.api.endpoints.summoner.dto.Summoner"%>
<%@ page import="net.rithms.riot.constant.Platform"%>
<%@ page import="net.rithms.riot.api.endpoints.match.*"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.Match"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.MatchList"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.MatchReference"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.Participant"%>
<%@ page
	import="net.rithms.riot.api.endpoints.match.dto.ParticipantStats"%>
<%@ page import="net.rithms.riot.api.endpoints.league.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.methods.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.constant.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.dto.*"%>

<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String name = request.getParameter("userGameID");
	System.out.println(name);

	SummonerDAO summonerDAO = new SummonerDAO();
	boolean found;
	found = summonerDAO.foundSummoner(name);
%>

	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	%>


<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
  <title><%=name %>의 전적정보</title>

  <!-- Bootstrap core CSS -->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  
  <!-- Custom fonts for this template -->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
  <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

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
					<li class="nav-item active">
						<a class="nav-link" href="index.jsp">전적 검색</a>
					</li>
					<li class="nav-item"><a class="nav-link" href="myrecord.jsp">내 전적</a></li>
					<li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
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

	<!-- Masthead -->
	<header class="masthead text-white text-center">
		<div class="overlay"></div>
		<div class="container">
			<div class="row">
				<div class="col-xl-9 mx-auto">
					<h1 class="mb-5">전적 검색</h1>
				</div>
				<div class="col-md-10 col-lg-8 col-xl-7 mx-auto">
					<form method="post" action="/LOL_ledder/SearchSummoner.jsp">
						<div class="form-row">
							<div class="col-12 col-md-9 mb-2 mb-md-0">
								<input type="text" name="userGameID"
									class="form-control form-control-lg"
									placeholder="소환사 명을 입력하세요.">
							</div>
							<div class="col-12 col-md-3">
								<button type="submit" class="btn btn-block btn-lg btn-primary">소환사 검색</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</header>

  <!-- include -->
  <%	
	  try{		
			LOLApiKey key = new LOLApiKey();
			//api key 설정
			ApiConfig cfg = key.getConfig();
			//api패스 설정
			RiotApi api = new RiotApi(cfg);
			//소환사 이름으로 소환사id값을 찾기위함
			Summoner summoner = api.getSummonerByName(Platform.KR, request.getParameter("userGameID"));
			if(found){
				System.out.println("found!");
				%><jsp:include page="SearchDBData.jsp" flush="false"/> 
				<jsp:include page="SearchMatchList.jsp" flush="flase"/><%
			}else{
				System.out.println("not found");
				%><jsp:include page="SearchDataRequest.jsp" flush="false"/>
				<jsp:include page="SearchDBData.jsp" flush="flase"/>
				<jsp:include page="SearchMatchList.jsp" flush="flase"/><%
			}
	  }catch(Exception e){
		  	out.println("<script>alert('소환사명 검색 실패');</script>");
	  }
	%>
	
  <!-- Bootstrap core JavaScript -->
  <script src="vendor/jquery/jquery.slim.min.js"></script>
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>

</html>
