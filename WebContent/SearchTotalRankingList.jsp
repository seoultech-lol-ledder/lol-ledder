<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<%@ page import="Resources.SummonerDatas"%>

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
	
	
	String name = request.getParameter("name");
	Connection dbcon = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	SummonerDatas sd = new SummonerDatas();
	ArrayList<SummonerDatas> sdList = new ArrayList<SummonerDatas>();
	double avg = 0;
	
	String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?serverTimezone=UTC";
	String DB_USER = "root";
	String DB_PASSWORD = "root";
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	}
	//소환사정보 디비검색
	try {
		dbcon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "select * from tsummoner order by rankpoint DESC";
		pstmt = dbcon.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd = new SummonerDatas();
			sd.setAccountId(rs.getString("accountid")); //계정아이디
			sd.setId(rs.getString("summonerid")); //소환사아이디
			sd.setName(rs.getString("summonername")); //소환사명
			sd.setSummonerLevel(rs.getLong("summonerlevel")); //소환사레벨
			sd.setProfileIconId(rs.getInt("profileiconid")); //프로필
			sd.setRank(rs.getString("rank_pos")); //소환사 랭크
			sd.setTier(rs.getString("tier")); //소환사 티어
			sd.setWin(rs.getInt("wins")); //소환사 승리
			sd.setLosses(rs.getInt("losses")); //소환사 패배
			sd.setLeagueName(rs.getString("leaguename")); //리그명
			sd.setLeaguePoints(rs.getInt("leaguepoints")); //리그포인트
			sd.setTotalGame(rs.getInt("totalgames"));
			sdList.add(sd);
		}
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("소환사 정보 불러오기 오류");
	}
	pstmt.close();
	rs.close();
	dbcon.close();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>랭킹 테이블</title>

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
          <div class="card-header">이용자 롤 랭킹</div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0" >
                <thead>
                  <tr>
                    <th>랭킹</th>
                    <th>소환사 명</th>
                    <th>티어</th>
                    <th>LP</th>
                    <th>레벨</th>
                    <th>승리</th>
                    <th>패배</th>
                    <th>승률</th>
                  </tr>
                </thead>
                <tbody>
                <%
                int ranking = 1;
                for(SummonerDatas i : sdList){ %>
                  <tr>
                    <td style="vertical-align:middle"><%=ranking++%></td>
                    <td style="vertical-align:middle"><%=i.getName()%></td>
                  	<td style="vertical-align:middle"><%=i.getTier() +" "+ i.getRank()%>
                  	<td style="vertical-align:middle"><%=i.getLeaguePoints() %>
                  	<td style="vertical-align:middle"><%=i.getSummonerLevel() %>
                  	<td style="vertical-align:middle"><%=i.getWin() %>
					<td style="vertical-align:middle"><%=i.getLosses()%></td>
					<td style="vertical-align:middle"><%=(int)(((float)i.getWin() / (i.getWin() + i.getLosses()) )*100) %>%
                  </tr>
                  <%} %>
                </tbody>
              </table>
            </div>
          </div>
          <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
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