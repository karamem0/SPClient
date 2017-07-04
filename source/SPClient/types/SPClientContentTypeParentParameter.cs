﻿/*
 * SPClientContentTypeParentParameter.cs
 *
 * Copyright (c) 2017 karamem0
 *
 * This software is released under the MIT License.
 * https://github.com/karamem0/SPClient/blob/master/LICENSE
 */

namespace SPClient {

    /// <summary>
    /// Represents the SPClientContentType functions parameter.
    /// </summary>
    public class SPClientContentTypeParentParameter {
        
        /// <summary>
        /// Gets the parent client object.
        /// </summary>
        public Microsoft.SharePoint.Client.ClientObject ClientObject { get; private set; }

        /// <summary>
        /// Initializes the new instance of <see cref="SPClient.SPClientContentTypeParentParameter"/> class.
        /// </summary>
        /// <param name="clientObject">the parent client object which contains content types.</param>
        public SPClientContentTypeParentParameter(Microsoft.SharePoint.Client.Web clientObject) {
            this.ClientObject = clientObject;
        }
        
        /// <summary>
        /// Initializes the new instance of <see cref="SPClient.SPClientContentTypeParentParameter"/> class.
        /// </summary>
        /// <param name="clientObject">the parent client object which contains content types.</param>
        public SPClientContentTypeParentParameter(Microsoft.SharePoint.Client.List clientObject) {
            this.ClientObject = clientObject;
        }

    }

}
