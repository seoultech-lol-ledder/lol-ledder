package Resources;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import net.rithms.riot.*;
import net.rithms.riot.api.ApiConfig;
import net.rithms.riot.api.RiotApi;
import net.rithms.riot.api.RiotApiException;
import net.rithms.riot.api.endpoints.summoner.dto.Summoner;
import net.rithms.riot.constant.Platform;
import net.rithms.riot.api.endpoints.match.*;
import net.rithms.riot.api.endpoints.match.dto.Match;
import net.rithms.riot.api.endpoints.match.dto.MatchList;
import net.rithms.riot.api.endpoints.match.dto.MatchReference;
import net.rithms.riot.api.endpoints.match.dto.Participant;
import net.rithms.riot.api.endpoints.match.dto.ParticipantIdentity;
import net.rithms.riot.api.endpoints.match.dto.ParticipantStats;
import net.rithms.riot.api.endpoints.match.dto.TeamStats;
import net.rithms.riot.api.endpoints.static_data.dto.Champion;
import net.rithms.riot.api.endpoints.champion.dto.ChampionList;
import net.rithms.riot.api.endpoints.league.*;
import net.rithms.riot.api.endpoints.league.methods.*;
import net.rithms.riot.api.endpoints.league.constant.*;
import net.rithms.riot.api.endpoints.league.dto.*;

public class testBean {
	
	public static void main(String[] args) throws RiotApiException {	
		//api key ����
		ApiConfig config = new ApiConfig().setKey("RGAPI-f249484a-e771-47db-9fd2-16be2b1b7a4c");
		//api�н� ����
		RiotApi api = new RiotApi(config);
		//��ȯ�� �̸����� ��ȯ��id���� ã������
		Summoner summoner = api.getSummonerByName(Platform.KR, "����");
		
		String name = summoner.getName(); //��ȯ���̸�
		long acountId = summoner.getAccountId(); //���� ���̵�
		long id = summoner.getId(); // ��ȯ�� ���̵�
		long summonerLevel = summoner.getSummonerLevel(); //��ȯ�� ����
		int profileIconId = summoner.getProfileIconId(); //�����ʾ����ܾ��̵�
		
		//�ֱ� 20��⿡ ���� ��ġ����Ʈ
		MatchList matchList = api.getRecentMatchListByAccountId(Platform.KR, acountId);
		//���׸���Ʈ�� ���õ� ����
		List<LeagueList> leagueList = api.getLeagueBySummonerId(Platform.KR, summoner.getId());
		//���������ǿ� ���õ� ����
		Set<LeaguePosition> leaguePosition = api.getLeaguePositionsBySummonerId(Platform.KR, summoner.getId());
		//������������ ��� �ؽ����̹Ƿ� get()�޼ҵ带 ����� �� ���⶧���� ��̸���Ʈ�� �ٲ㼭 �����Ͽ� ��������
		//�̶� �ؽ��¿� ����ִ� ������ ��ü.size()�� Ȯ���ϱ�...int index = ��ü.size();
		List<LeaguePosition> tempList = new ArrayList<LeaguePosition>(leaguePosition);
		//��ġ����Ʈ�� ���õ� ���۷�����
		List<MatchReference> matchListRef = matchList.getMatches();		
		/*System.out.println("���� ���� : " + leagueList.get(0).getName());//�����̸�
		System.out.println("���� Ƽ�� : " + leagueList.get(0).getTier());//Ƽ������*/
		//��ġ ���ݰ��� ������
		Match checkStats = api.getMatch(Platform.KR,matchListRef.get(0).getGameId());
		//List<Participant> partList = checkStats.getParticipants();
		//Champion champion = api.get

		String leagueName = tempList.get(0).getLeagueName();//�����̸�
		int leaguePoints = tempList.get(0).getLeaguePoints();//��������Ʈ
		String rank = tempList.get(0).getRank();//���緩ũ
		String tier = tempList.get(0).getTier();//����Ƽ��
		int win = tempList.get(0).getWins();//�¸�Ƚ��
		int losses = tempList.get(0).getLosses();//�й�Ƚ��
		
		int championId = checkStats.getParticipants().get(0).getChampionId();//è�Ǿ���̵�
		int kill = checkStats.getParticipants().get(0).getStats().getKills();//ųȽ��
		int death = checkStats.getParticipants().get(0).getStats().getDeaths();//����Ƚ��
		int assist = checkStats.getParticipants().get(0).getStats().getAssists();//��ý�Ʈ
		List<MatchReference> temp = matchList.getMatches();
		Match temp2 = api.getMatch(Platform.KR, temp.get(0).getGameId());
		List<ParticipantIdentity> temp3 = temp2.getParticipantIdentities();
		List<TeamStats> temp4 = temp2.getTeams();
		
		System.out.println(temp2.getTeams());
		System.out.println(temp3);
		for(int i=0;i<20;i++){
			System.out.println(temp.get(i));
			System.out.println(temp.get(i).getGameId());
		}
		System.out.println(matchListRef);
		System.out.println(checkStats);
		System.out.println(checkStats.getParticipants().get(0));
	}
}