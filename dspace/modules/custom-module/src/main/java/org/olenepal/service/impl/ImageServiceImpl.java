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

package org.olenepal.service.impl;

import java.util.List;

import org.olenepal.dao.ImageDAO;
import org.olenepal.model.Image;
import org.olenepal.service.ImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ImageServiceImpl implements ImageService {

	@Autowired
	ImageDAO imageDAO;

	@Override
	public Image findImageById(Long id) {

		return imageDAO.findImageById(id);
	}

	@Override
	public List<Image> findAllImage() {
		// TODO Auto-generated method stub
		return imageDAO.findAllImage();
	}

	@Override
	public void saveImage(Image image) {
		imageDAO.save(image);

	}

	@Override
	public void deleteImageById(Long id) {
		imageDAO.deleteImageById(id);

	}

}
