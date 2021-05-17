-- Copied from @danielma/dotfiles

browsers = {
   { "Safari", "com.apple.Safari" },
   { "Firefox", "org.mozilla.firefox" },
   { "Google Chrome", "com.google.chrome" },
   { "Brave Browser", "com.brave.browser" },
   { "Microsoft Edge", "com.microsoft.edgemac" }
}
lastBrowser = "Safari"

function launchBrowser()
   launch(lastBrowser)
end

function browserEvent(appName, eventType, app)
   if eventType ~= hs.application.watcher.activated then
      return
   end

   for _, browser in ipairs(browsers) do
      if browser[1] == appName then
         if appName ~= lastBrowser then
            print("changing browser from " .. lastBrowser .. " to " .. appName)
            lastBrowser = appName
         end

         break
      end
   end
end

browserWatcher = hs.application.watcher.new(browserEvent)
browserWatcher:start()

function httpCallback(scheme, _, _, fullURL)
   local spotifyRegex = "^https://open.spotify.com/"
   local notionRegex = "^https://.*notion.so/"
   local zoomRegex = "^https://.*zoom.us/j/(%d+)"
   local zoomWithPasswordRegex = "^https://.*zoom.us/j/(%d+)?pwd=(%w+)"

   if fullURL:match(spotifyRegex) then
      fullURL = fullURL:gsub(spotifyRegex, "spotify://")
      hs.urlevent.openURL(fullURL)
   elseif fullURL:match(notionRegex) then
      fullURL = fullURL:gsub(notionRegex, "notion://")
      hs.urlevent.openURL(fullURL)
   elseif fullURL:match(zoomWithPasswordRegex) then
      fullURL = fullURL:gsub(zoomWithPasswordRegex, "zoommtg://zoom.us/join?confno=%1&pwd=%2")
      hs.urlevent.openURL(fullURL)
   elseif fullURL:match(zoomRegex) then
      fullURL = fullURL:gsub(zoomRegex, "zoommtg://zoom.us/join?confno=%1")
      hs.urlevent.openURL(fullURL)
   else
      for _, browser in ipairs(browsers) do
         if browser[1] == lastBrowser then
            local frontmostApp = hs.application.frontmostApplication()
            print(frontmostApp:bundleID())
            local isHammerspoon = frontmostApp:bundleID() == "org.hammerspoon.Hammerspoon"
            print(hs.urlevent.openURLWithBundle(fullURL, browser[2]))
            break
         end
      end
   end
end

hs.urlevent.httpCallback = httpCallback
