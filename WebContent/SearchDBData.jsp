<%@ page import="Resources.SummonerDatas"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String name = request.getParameter("name");
	Connection dbcon = null;
	//PreparedStatement pstmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	SummonerDatas sd = new SummonerDatas();
	double avg = 0;
	String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
	String DB_USER = "root";
	String DB_PASSWORD = "root";
	try {
		Class.forName("com.mysql.jdbc.Driver");
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	}
	//소환사정보 디비검색
	try {
		dbcon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "select * from tsummoner where summonername=?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setString(1, name);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setAccountId(rs.getString("accountid")); //계정아이디
			sd.setId(rs.getString("summonerid")); //소환사아이디
			sd.setName(rs.getString("summonername")); //소환사명
			sd.setSummonerLevel(rs.getLong("summonerlevel")); //소환사레벨
			sd.setProfileIconId(rs.getInt("profileiconid")); //프로필
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	//티어정보 디비검색
	try {
		String sql = "select * from ttierlist where summonerid =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setString(1, sd.getId()); //소환사아이디로 쿼리문받기
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setRank(rs.getString("rank_pos")); //소환사 랭크
			sd.setTier(rs.getString("tier")); //소환사 티어
			sd.setWin(rs.getInt("wins")); //소환사 승리
			sd.setLosses(rs.getInt("losses")); //소환사 패배
			sd.setLeagueName(rs.getString("leaguename")); //리그명
			sd.setLeaguePoints(rs.getInt("leaguepoints")); //리그포인트
		}
	} catch (Exception e) {
		//e.printStackTrace();
		System.out.println("티어정보 불러오기 오류");
	}
	//매치정보디비검색
	try {
		String sql = "select * from tmatchlist where summonerid =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setString(1, sd.getId());
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setTotalGame(rs.getInt("totalgames"));
			sd.setParticipateId(rs.getInt("participateid"));
		}
	} catch (Exception e) {
		//e.printStackTrace();
		System.out.println("매칭정보 불러오기 오류");
	}
	//챔피언정보
	try {
		String sql = "select * from tChampion_data where CHAMPION_ID =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setInt(1, sd.getChampionId());
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setChampionName(rs.getString("CHAMPION_NAME"));
			sd.setImage(rs.getString("image"));
		}
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("챔피언아이디 불러오기 오류");
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