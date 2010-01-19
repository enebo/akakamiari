package org.jruby.ant;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.jruby.embed.ScriptingContainer;

public class Rake extends Task {
    private String filename;
    private String taskname; // A list?

    @Override
    public void execute() throws BuildException {
        List args = new ArrayList();

        if (filename != null) {
            args.add("-f");
            args.add(filename);
        }

        if (taskname != null) {
            args.add(taskname);
        }

        System.setProperty("jruby.native.enabled", "false"); // Problem with cl w/ jnr + jffi
        ScriptingContainer container = new ScriptingContainer();

        // ENEBO: This needs to be replaced by something which does not assume CWD
        container.setLoadPaths(Arrays.asList("lib"));
        container.runScriptlet("require 'ant/tasks/rake'");
        container.put("$project", getProject());             // set project so jruby ant lib gets it

        try {
            Object rakeInstance = container.runScriptlet("RakeWrapper.new");
            container.callMethod(rakeInstance, "execute", args.toArray(new Object[args.size()]));
        } catch (Exception e) {
            throw new BuildException("Build failed: " + e.getMessage(), e);
        }
    }

    public void setFile(String filename) {
        this.filename = filename;
    }

    // ENEBO: Allow list of tasks to be executed
    public void setTask(String taskname) {
        this.taskname = taskname;
    }

    // ENEBO: Add flag to allow registering all defined ant tasks in Rake dependency tree.
}
