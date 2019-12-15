<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<%@ page import="Resources.SummonerDatas"%>
<%@ page import="Resources.LOLApiKey"%>
<%@ page import="Resources.SummonerDAO"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.io.PrintWriter"%>

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
<%@ page import="net.rithms.riot.api.endpoints.match.dto.ParticipantStats"%>
<%@ page import="net.rithms.riot.api.endpoints.league.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.methods.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.constant.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.dto.*"%>

<%
	request.setCharacterEncoding("utf-8");
%>

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
	%>
	
<%
	SummonerDatas sd = new SummonerDatas();
	SummonerDAO summonerDAO = new SummonerDAO();
	String summonerName = summonerDAO.getSummonerName(userID);
	summonerDAO.setSummonerData(summonerName, sd);

	LOLApiKey key = new LOLApiKey();
	//api key 설정
	ApiConfig cfg = key.getConfig();
	//api패스 설정
	RiotApi api = new RiotApi(cfg);
	//소환사 이름으로 소환사id값을 찾기위함
	Summoner summoner = api.getSummonerByName(Platform.KR, summonerName);
	//소환사 정보
	String name = summoner.getName(); //소환사이름
	String acountId = summoner.getAccountId(); //계정 아이디
	String id = summoner.getId(); // 소환사 아이디

	//최근 20경기에 대한 매치리스트
	MatchList matchList = api.getMatchListByAccountId(Platform.KR, acountId);
	
	//매치리스트와 관련된 레퍼런스들
	List<MatchReference> matchListRef = matchList.getMatches();
	
	long[] goldEarned = new long[20];
	String[] isWin = new String[20];
	int[] championId = new int[20];
	int[] kill = new int[20];
	int[] death = new int[20];
	int[] assist = new int[20];
	int[] championLevel = new int[20];
	int[] minionKill = new int[20];
	long[] visionScore = new long[20];
	String[] championName = new String[20];
	String[] image = new String[20];
	
	for(int i = 0 ; i < 10 ; i++){
		//매치 스텟관련 정보들
		Match checkStats = api.getMatch(Platform.KR, matchListRef.get(i).getGameId());

	
		//소환사 매치정보
		goldEarned[i] = checkStats.getParticipantBySummonerName(name).getStats().getGoldEarned();
		if(checkStats.getParticipantBySummonerName(name).getStats().isWin()== true){
			isWin[i] = "승리";
		}else{
			isWin[i] = "패배";
		}
		
		championId[i] = checkStats.getParticipantBySummonerName(name).getChampionId();//챔피언아이디
		kill[i] = checkStats.getParticipantBySummonerName(name).getStats().getKills();//킬횟수
		death[i] = checkStats.getParticipantBySummonerName(name).getStats().getDeaths();//죽은횟수
		assist[i] = checkStats.getParticipantBySummonerName(name).getStats().getAssists();//어시스트
		championLevel[i] = checkStats.getParticipantBySummonerName(name).getStats().getChampLevel();
		minionKill[i] = checkStats.getParticipantBySummonerName(name).getStats().getTotalMinionsKilled()
				+ checkStats.getParticipantBySummonerName(name).getStats().getNeutralMinionsKilled();
		visionScore[i] = checkStats.getParticipantBySummonerName(name).getStats().getVisionScore();
			
	}
	
	
	double[] avg = new double[10];
	
	//챔피언정보
	for(int i = 0 ; i < 10 ; i++){
		championName[i] = summonerDAO.getChampionName(championId[i]);
		image[i] = summonerDAO.getChampionImage(championId[i]);
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>내 전적</title>

  <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="css/sb-admin.css" rel="stylesheet">

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
					<li class="nav-item active"><a class="nav-link" href="myrecord.jsp">내 전적</a></li>
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

<!--전체 전적 -->
        <div class="card mb-3">
          <div class="card-header">
            <%=sd.getName() %>님의 전체 전적  </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th>소환사명</th>
                    <th>레벨</th>
                    <th>티어</th>
                    <th>리그포인트</th>
                    <th>랭크 게임 승리</th>
                    <th>랭크 게임 패배</th>
                    <th>플레이한 게임 수</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
					<td><%=sd.getName() %></td>
					<td><%=sd.getSummonerLevel() %></td>
					<td><%=sd.getTier()+" "+sd.getRank() %></td>
					<td><%=sd.getLeaguePoints()+"LP" %></td>
					<td><%=sd.getWin()+"승" %></td>
					<td><%=sd.getLosses()+"패" %></td>
					<td><%="총 "+sd.getTotalGame()+"회" %></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>


<!-- 최근 전적 -->
        <div class="card mb-3">
          <div class="card-header">
            <%= name %>님의 최근 전적</div>
          <div class="card-body">
            <div class="table-responsive">
	            <%
	            for(int i = 0 ; i < 10 ; i++){
					avg[i] = kill[i] + assist[i];
					avg[i] = avg[i] /death[i];
					avg[i] = Double.parseDouble(String.format("%.2f", avg[i]));
	            }
				%>
              <table class="table table-bordered" width="100%" cellspacing="0" >
                <thead>
                  <tr>
                    <th>플레이한 챔피언</th>
                    <th>결과</th>
                    <th>레벨</th>
                    <th>CS</th>
                    <th>시야점수</th>
                    <th>KDA</th>
                    <th>골드</th>
                  </tr>
                </thead>
                <tbody>
                <%for(int i = 0 ; i < 10 ; i++){ %>
                  <tr>
                    <td style="vertical-align:middle"><img src="Champions/<%=image[i]%>.png"><br><%=championName[i] %></td>
                  	<td style="vertical-align:middle"><%=isWin[i] %>
                  	<td style="vertical-align:middle"><%=championLevel[i] %>
                  	<td style="vertical-align:middle"><%=minionKill[i] %>
                  	<td style="vertical-align:middle"><%=visionScore[i] %>
					<td style="vertical-align:middle"><%=kill[i]+"킬<br>"+death[i]+"데스<br>"+assist[i] +"어시<br>"+"평점 :"+avg[i]%></td>
					<td style="vertical-align:middle"><%=goldEarned[i] %>
                  </tr>
                  <%} %>
                </tbody>
              </table>
            </div>
          </div>
          <div class="card-footer small text-muted">Updated at <%= (new java.util.Date()).toLocaleString() %> </div>
        </div>
      
  <!-- Bootstrap core JavaScript-->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Page level plugin JavaScript-->
  <script src="vendor/datatables/jquery.dataTables.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="js/sb-admin.min.js"></script>

  <!-- Demo scripts for this page-->
  <script src="js/demo/datatables-demo.js"></script>
  
</body>
</html>