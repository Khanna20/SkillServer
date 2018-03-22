package com.harman.skillserver.rest;

import java.io.IOException;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.harman.skillserver.beans.AccessTokenUpdate;
import com.harman.skillserver.service.UserService;
import com.harman.utils.ErrorType;
import com.harman.utils.HarmanParser;

@RestController
@RequestMapping("/Skill")
public class SkillServerController {

	@Autowired
	UserService userService;

	@RequestMapping(value = "/UpdateSkill", method = RequestMethod.POST)
	public @ResponseBody String requestCMD(@RequestBody String requestBody) throws IOException {

		System.out.println(requestBody);
		ErrorType errorType = ErrorType.NO_ERROR;
		JSONObject response = new JSONObject();
		try {
			Map<String, String> mapList = new HarmanParser().parseData(requestBody);
			switch (errorType) {
			case NO_ERROR:
				response.put("Status", 1);
				break;

			default:
				response.put("Status", 0);
				break;
			}
			response.put("cmd", "UpdateSmartAudioAnalyticsRes");
		} catch (Exception e) {
			response.put("Status", 0);
			response.put("cmd", "UpdateSmartAudioAnalyticsRes");
			System.out.println("fail to parse");
		}
		System.out.println(errorType.name());
		return response.toString();
	}

	@RequestMapping(value = "/UpdateAccessToken", consumes = { MediaType.APPLICATION_JSON_VALUE,
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE,
					MediaType.APPLICATION_JSON_VALUE }, method = RequestMethod.POST)
	public @ResponseBody AccessTokenUpdate updateAcessToken(@RequestBody AccessTokenUpdate requestBody)
			throws IOException {

		try {
			if (null != requestBody.getAccessToken() && null != requestBody.getEmailID()
					&& null != requestBody.getUsername())
				System.out.println("successfully get the access token");
			userService.updateAccessToken(requestBody);

		} catch (Exception e) {
			System.out.println("fail to parse");
		}
		return requestBody;
	}

}
