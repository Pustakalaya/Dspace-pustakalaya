/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.olenepal.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.olenepal.model.FileBucket;
import org.olenepal.model.Image;
import org.olenepal.service.ImageService;
import org.olenepal.validator.FileValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;


@Controller
public class UploadController {
	     
    @Autowired
    ImageService imageService;
     
    @Autowired
    MessageSource messageSource;
 
    @Autowired
    FileValidator fileValidator;
     
    @InitBinder("fileBucket")
    protected void initBinder(WebDataBinder binder) {
       binder.setValidator(fileValidator);
    }
 
    @RequestMapping(value="/app",method=RequestMethod.GET)
    @ResponseBody
    public String index(ModelMap map){
    	map.addAttribute("images", imageService.findAllImage());
    	return "index";
    }
     
    @RequestMapping(value = { "/add-image" }, method = RequestMethod.GET)
    public String addDocuments(@PathVariable Long id, ModelMap model) {
        Image image = imageService.findImageById(id);
        model.addAttribute("image", image);
 
        FileBucket fileModel = new FileBucket();
        model.addAttribute("fileBucket", fileModel);
 
        List<Image> images = (List<Image>) imageService.findImageById(id);
        model.addAttribute("images", images);
         
        return "image uploaded";
    }
     
    @RequestMapping(method = RequestMethod.POST, value = "/image/rest/save")
	public @ResponseBody List<Image> uploadImageBanner(
			@RequestParam("tagline")String tagline,
			@RequestParam("image") MultipartFile file) throws IOException {
		
		List<Image> images=new ArrayList<>();
		Image image=new Image();
		image.setId(new Long("1901"));
		image.setTagline(tagline);
		image.setTitle("This is image uploaded");
		byte[] file1=file.getBytes();
		image.setImage(file1);
		image.setDisplay(false);
	
		imageService.saveImage(image);
		
		
		return  images;
	}
     
	


}
