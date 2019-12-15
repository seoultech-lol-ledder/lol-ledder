<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="Resources.LOLApiKey"%>
<%@ page import="Resources.SummonerDAO"%>
	
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
		LOLApiKey key = new LOLApiKey();
		//api key 설정
		ApiConfig cfg = key.getConfig();
		//api패스 설정
		RiotApi api = new RiotApi(cfg);
		//소환사 이름으로 소환사id값을 찾기위함
		Summoner summoner = api.getSummonerByName(Platform.KR, request.getParameter("userGameID"));
		//소환사 정보
		String name = summoner.getName(); //소환사이름
		String acountId = summoner.getAccountId(); //계정 아이디
		String id = summoner.getId(); // 소환사 아이디
		int summonerLevel = summoner.getSummonerLevel(); //소환사 레벨
		int profileIconId = summoner.getProfileIconId(); //프로필아이콘아이디
		//최근 20경기에 대한 매치리스트
		MatchList matchList = api.getMatchListByAccountId(Platform.KR, acountId);
		//리그엔트리에 관련된 정보
		Set<LeagueEntry> leagueEntry = api.getLeagueEntriesBySummonerId(Platform.KR, id);
		//리그포지션의 경우 해쉬셋이므로 get()메소드를 사용할 수 없기때문에 어레이리스트로 바꿔서 저장하여 가져오기
		//이때 해쉬셋에 들어있는 정보는 객체.size()로 확인하기...int index = 객체.size();
		List<LeagueEntry> tempList = new ArrayList<LeagueEntry>(leagueEntry);
		//매치리스트와 관련된 레퍼런스들
		List<MatchReference> matchListRef = matchList.getMatches();
		//매치 스텟관련 정보들
		Match checkStats = api.getMatch(Platform.KR, matchListRef.get(0).getGameId());
		//소환사 티어정보
		String leagueName = tempList.get(0).getLeagueId();//리그이름
		int leaguePoints = tempList.get(0).getLeaguePoints();//리그포인트
		String rank = tempList.get(0).getRank();//현재랭크
		String tier = tempList.get(0).getTier();//현재티어
		int win = tempList.get(0).getWins();//승리횟수
		int losses = tempList.get(0).getLosses();//패배횟수
		int totalGames = win + losses;//총 플레이 횟수

		int rankPoint = 0;
		switch(tier) {
		case "CHALLENGER":
			rankPoint += 8000;
			break;
		case "GRANDMASTER":
			rankPoint += 7000;
			break;
		case "MASTER":
			rankPoint += 6000;
			break;
		case "DIAMOND":
			rankPoint += 5000;
			break;
		case "PLATINUM":
			rankPoint += 4000;
			break;
		case "GOLD":
			rankPoint += 3000;
			break;
		case "SILBER":
			rankPoint += 2000;
			break;
		case "BRONZE":
			rankPoint += 1000;
			break;
		case "IRON":
			rankPoint += 0;
			break;
		}
		
		switch(rank) {
		case "I":
			rankPoint += 800;
			break;
		case "II":
			rankPoint += 600;
			break;
		case "III":
			rankPoint += 400;
			break;
		case "IV":
			rankPoint += 200;
			break;
		case "V":
			rankPoint += 0;
			break;
		}
		
		rankPoint += leaguePoints;

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	body{
		background-color : #5CD1E5;
		background-image : url(mainimage.jpg);background-size : 100%;
	}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>데이터 저장 중
</title>
</head>
<body>
	<%
		SummonerDAO summonerDAO = new SummonerDAO();
		summonerDAO.insertSummoner(id, acountId, name, summonerLevel, profileIconId, tier, rank,
				win, losses, leaguePoints, leagueName, totalGames, rankPoint);
	%>

</body>
</html>