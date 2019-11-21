<%@ page import="Resources.SummonerDatas"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>

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
	//request에서 온 부분
	//api key 설정
	ApiConfig cfg = new ApiConfig().setKey("RGAPI-329cf0ef-286c-4e81-b472-176dcdb0b23f");
	//api패스 설정
	RiotApi api = new RiotApi(cfg);
	//소환사 이름으로 소환사id값을 찾기위함
	Summoner summoner = api.getSummonerByName(Platform.KR, request.getParameter("name"));
	//소환사 정보
	String name = summoner.getName(); //소환사이름
	String acountId = summoner.getAccountId(); //계정 아이디
	String id = summoner.getId(); // 소환사 아이디

	//최근 20경기에 대한 매치리스트
	MatchList matchList = api.getMatchListByAccountId(Platform.KR, acountId);
	
	//매치리스트와 관련된 레퍼런스들
	List<MatchReference> matchListRef = matchList.getMatches();
	
	int[] championId = new int[20];
	int[] kill = new int[20];
	int[] death = new int[20];
	int[] assist = new int[20];
	String[] championName = new String[20];
	String[] image = new String[20];
	for(int i = 0 ; i < 2 ; i++){
		//매치 스텟관련 정보들
		Match checkStats = api.getMatch(Platform.KR, matchListRef.get(i).getGameId());

	
		//소환사 매치정보
		championId[i] = checkStats.getParticipants().get(i).getChampionId();//챔피언아이디
		kill[i] = checkStats.getParticipants().get(i).getStats().getKills();//킬횟수
		death[i] = checkStats.getParticipants().get(i).getStats().getDeaths();//죽은횟수
		assist[i] = checkStats.getParticipants().get(i).getStats().getAssists();//어시스트

	}
	
	//search 에서 온 부분
	
	Connection dbcon = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	SummonerDatas sd = new SummonerDatas();
	double avg = 0;
	String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?serverTimezone=UTC";
	String DB_USER = "root";
	String DB_PASSWORD = "root";
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	}
	//챔피언정보
	for(int i = 0 ; i < 2 ; i++){
		try {
			String sql = "select * from tChampion_data where CHAMPION_ID =?";
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, championId[i]);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				championName[i] = rs.getString("CHAMPION_NAME");
				image[i] = rs.getString("image");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("챔피언아이디 불러오기 오류");
		}
	}
	
	pstmt.close();
	rs.close();
	dbcon.close();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

	<meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>전적 검색 테이블</title>

  <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="css/sb-admin.css" rel="stylesheet">

</head>

<body>

<!-- DataTables Example -->
        <div class="card mb-3">
          <div class="card-header">
            <%=sd.getName() %>님의 전적</div>
          <div class="card-body">
            <div class="table-responsive">
	            <%
					avg = sd.getKill() + sd.getAssist();
					avg = avg / sd.getDeath();
					avg = Double.parseDouble(String.format("%.2f", avg));
				%>
              <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th>소환사명</th>
                    <th>레벨</th>
                    <th>티어</th>
                    <th>리그포인트</th>
                    <th>랭크 게임 승리</th>
                    <th>랭크 게임 패배</th>
                    <th>플레이한 게임 수</th>
                    <th>최근 플레이한 챔피언</th>
                    <th>KDA</th>
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
					<td><img src="Champions/<%=sd.getImage()%>.png"></br><%=sd.getChampionName() %></td>
					<td><%=sd.getKill()+"킬\n"+sd.getDeath()+"데스\n"+sd.getAssist() +"어시\n"+"</br>평점 :"+avg%></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
        </div>

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