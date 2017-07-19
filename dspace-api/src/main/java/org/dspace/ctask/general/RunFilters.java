/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.ctask.general;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.lang.Runtime;

import org.dspace.content.*;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.BitstreamFormatService;
import org.dspace.curate.AbstractCurationTask;
import org.dspace.curate.Curator;
import org.dspace.curate.Distributive;

/**
 *
 * @author Melech Maglasang
 */
@Distributive
public class RunFilters extends AbstractCurationTask
{
    // map of formats to occurrences

    /**
     * Perform the curation task upon passed DSO
     *
     * @param dso the DSpace object
     * @throws IOException if IO error
     */
    @Override
    public int perform(DSpaceObject dso) throws IOException
    {
        if (mediaRun()) {
            return Curator.CURATE_SUCCESS;
        }
        return Curator.CURATE_FAIL;
    }
    
    private boolean mediaRun(){
        try{
            final String cmd = "/dspace/bin/dspace filter-media";

            Process process = Runtime.getRuntime().exec(cmd);

            return true;

        }
        catch (Exception e){
            return false;
        }

    }
}

    
