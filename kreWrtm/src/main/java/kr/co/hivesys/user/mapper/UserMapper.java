package kr.co.hivesys.user.mapper;
import java.util.HashMap;
import java.util.List;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.user.vo.UserVO;

/**
 * 사용자 매퍼 클래스
 * @author 솔루션사업팀 정다빈
 * @since 2021.07.23
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2021.07.23  정다빈           최초 생성
 */

@Mapper("userMapper")
public interface UserMapper{
	//전체 회원정보 조회
	public List<UserVO> selectList(UserVO userVO) throws Exception;
	//특정 회원정보 조회
	public List<UserVO>  select(UserVO userVO) throws Exception;
	//사용자 등록
	public void insert(UserVO userVO) throws Exception;
	//사용자 정보 수정
	public void update(UserVO uvo);
	//사용자 삭제
	public void deleteChk(HashMap<String, Object> map);
	
}
