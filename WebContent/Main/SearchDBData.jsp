<%@ page import="Resources.SummonerDatas"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="EUC-KR"%>
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

	//참가자정보 디비검색
	try {
		String sql = "select * from tparticipatestat where participateid =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setInt(1, sd.getParticipateId());
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setChampionId(rs.getInt("championid"));
			sd.setKill(rs.getInt("kill_count"));
			sd.setDeath(rs.getInt("death"));
			sd.setAssist(rs.getInt("assist"));
		}
	} catch (Exception e) {
		//e.printStackTrace();
		System.out.println("참가자정보 불러오기 오류");
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
<style>
body {
	background-color: #5CD1E5;
	background-image: url(mainimage.jpg)
}

table {
	margin : 350px 0px 0px 380px;
	vertical-align : middle;
	border-collapse: collapse;
	width: 1200px;
}

table, tr, td {
	border: solid 1px #cccccc;
	color : #ffffff;
	font-family : "나눔고딕";
}

tr {
	hegiht: 40px;
	text-align: center;
}

#table_title {
	height: 10px;
	background-color: #280848;
}

setcolor{
	color : #ffffff;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	avg = sd.getKill() + sd.getAssist();
	avg = avg / sd.getDeath();
	avg = Double.parseDouble(String.format("%.2f", avg));
%>
	<table>
		<tr id="table_title">
			<td>소환사명</td>
			<td>레 벨</td>
			<td>티어</td>
			<td>리그명</td>
			<td>리그포인트</td>
			<td>랭크게임 승리</td>
			<td>랭크게임 패배</td>
			<td>총 플레이한 게임 수</td>
			<td>최근 플레이한 챔피언</td>
			<td>KDA</td>
		</tr>
		<tr>
			<td><%=sd.getName() %></td>
			<td><%=sd.getSummonerLevel() %></td>
			<td><%=sd.getTier()+" "+sd.getRank() %></td>
			<td><%=sd.getLeagueName() %></td>
			<td><%=sd.getLeaguePoints()+"LP" %></td>
			<td><%=sd.getWin()+"승" %></td>
			<td><%=sd.getLosses()+"패" %></td>
			<td><%="총 "+sd.getTotalGame()+"회" %></td>
			<td><img src="Champions/<%=sd.getImage()%>.png"></br><%=sd.getChampionName() %></td>
			<td><%=sd.getKill()+"킬"+sd.getDeath()+"데스"+sd.getAssist() +"어시"+"</br>평점 :"+avg%></td>			
		</tr>
	</table>
<%-- 	<%
		System.out.println(sd.getName());
		System.out.println(sd.getSummonerLevel());
		System.out.println(sd.getTier());
		System.out.println(sd.getRank());
		System.out.println(sd.getLeagueName());
		System.out.println(sd.getLeaguePoints());
		System.out.println(sd.getWin());
		System.out.println(sd.getLosses());
		System.out.println(sd.getTotalGame());
		System.out.println(sd.getKill());
		System.out.println(sd.getDeath());
		System.out.println(sd.getAssist());
		System.out.println(sd.getChampionName());
		System.out.println(sd.getImage());
	%> --%>
</body>
</html>