def scanDir(params , &block)
  dirPath, filter = params[:dirPath], params[:filter]
  files = []
  dirs = []
  Dir.foreach(dirPath).sort.each do|fName|
    path = "#{dirPath}/#{fName}"
    File.directory?(path) ? dirs << path : files << path
  end
  dirs.each do |dir|
    if not dir.end_with?('.')
      yield dir
      scanDir dirPath:dir, filter:filter, &block
    end
  end
  files.each do |file|
    require file if file.end_with?('.rb')
  end
end

def addDirsToLoadPath(*dirNames)
  dirNames.each do |name|
    full_path = name[0] == '/' ? name : File.join(File.dirname(__FILE__), name)
    scanDir dirPath: full_path, filter: ->(path){File.directory?(path)} do |path|
      $LOAD_PATH.unshift path
    end
  end
end

