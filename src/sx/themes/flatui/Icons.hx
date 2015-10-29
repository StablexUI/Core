package sx.themes.flatui;

import sx.themes.FlatUITheme;
import sx.themes.macro.Assets;
import sx.widgets.Bmp;
import sx.widgets.ScaleFit;


/**
 * Icons factory
 *
 */
class Icons
{
    /**
     * Set specified color for Bmp widget via tinting
     */
    static public dynamic function setColor (bmp:Bmp, color:Int) : Void
    {
        #if stablexui_flash
            var ct = bmp.renderer.transform.colorTransform;
            ct.color = color - 0xFFFFFF;
            bmp.renderer.transform.colorTransform = ct;
        #end
    }


    /**
     * Load bitmaps for icons
     */
    static public dynamic function loadBitmaps (onReady:Void->Void) : Void
    {
        #if stablexui_flash
            var data = Assets.bitmapData('assets/icons/triangle-up.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/triangle-up.png', data);
            var data = Assets.bitmapData('assets/icons/triangle-down.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/triangle-down.png', data);
            var data = Assets.bitmapData('assets/icons/triangle-up-small.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/triangle-up-small.png', data);
            var data = Assets.bitmapData('assets/icons/triangle-down-small.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/triangle-down-small.png', data);
            var data = Assets.bitmapData('assets/icons/triangle-left-large.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/triangle-left-large.png', data);
            var data = Assets.bitmapData('assets/icons/triangle-right-large.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/triangle-right-large.png', data);
            var data = Assets.bitmapData('assets/icons/arrow-left.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/arrow-left.png', data);
            var data = Assets.bitmapData('assets/icons/arrow-right.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/arrow-right.png', data);
            var data = Assets.bitmapData('assets/icons/plus.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/plus.png', data);
            var data = Assets.bitmapData('assets/icons/cross.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/cross.png', data);
            var data = Assets.bitmapData('assets/icons/check.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/check.png', data);
            var data = Assets.bitmapData('assets/icons/radio-unchecked.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/radio-unchecked.png', data);
            var data = Assets.bitmapData('assets/icons/radio-checked.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/radio-checked.png', data);
            var data = Assets.bitmapData('assets/icons/checkbox-unchecked.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/checkbox-unchecked.png', data);
            var data = Assets.bitmapData('assets/icons/checkbox-checked.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/checkbox-checked.png', data);
            var data = Assets.bitmapData('assets/icons/info-circle.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/info-circle.png', data);
            var data = Assets.bitmapData('assets/icons/alert-circle.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/alert-circle.png', data);
            var data = Assets.bitmapData('assets/icons/question-circle.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/question-circle.png', data);
            var data = Assets.bitmapData('assets/icons/check-circle.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/check-circle.png', data);
            var data = Assets.bitmapData('assets/icons/cross-circle.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/cross-circle.png', data);
            var data = Assets.bitmapData('assets/icons/plus-circle.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/plus-circle.png', data);
            var data = Assets.bitmapData('assets/icons/pause.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/pause.png', data);
            var data = Assets.bitmapData('assets/icons/play.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/play.png', data);
            var data = Assets.bitmapData('assets/icons/volume.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/volume.png', data);
            var data = Assets.bitmapData('assets/icons/mute.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/mute.png', data);
            var data = Assets.bitmapData('assets/icons/resize.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/resize.png', data);
            var data = Assets.bitmapData('assets/icons/list.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list.png', data);
            var data = Assets.bitmapData('assets/icons/list-thumbnailed.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list-thumbnailed.png', data);
            var data = Assets.bitmapData('assets/icons/list-small-thumbnails.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list-small-thumbnails.png', data);
            var data = Assets.bitmapData('assets/icons/list-large-thumbnails.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list-large-thumbnails.png', data);
            var data = Assets.bitmapData('assets/icons/list-numbered.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list-numbered.png', data);
            var data = Assets.bitmapData('assets/icons/list-columned.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list-columned.png', data);
            var data = Assets.bitmapData('assets/icons/list-bulleted.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/list-bulleted.png', data);
            var data = Assets.bitmapData('assets/icons/window.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/window.png', data);
            var data = Assets.bitmapData('assets/icons/windows.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/windows.png', data);
            var data = Assets.bitmapData('assets/icons/loop.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/loop.png', data);
            var data = Assets.bitmapData('assets/icons/cmd.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/cmd.png', data);
            var data = Assets.bitmapData('assets/icons/mic.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/mic.png', data);
            var data = Assets.bitmapData('assets/icons/heart.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/heart.png', data);
            var data = Assets.bitmapData('assets/icons/location.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/location.png', data);
            var data = Assets.bitmapData('assets/icons/new.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/new.png', data);
            var data = Assets.bitmapData('assets/icons/video.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/video.png', data);
            var data = Assets.bitmapData('assets/icons/photo.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/photo.png', data);
            var data = Assets.bitmapData('assets/icons/time.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/time.png', data);
            var data = Assets.bitmapData('assets/icons/eye.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/eye.png', data);
            var data = Assets.bitmapData('assets/icons/chat.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/chat.png', data);
            var data = Assets.bitmapData('assets/icons/home.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/home.png', data);
            var data = Assets.bitmapData('assets/icons/upload.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/upload.png', data);
            var data = Assets.bitmapData('assets/icons/search.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/search.png', data);
            var data = Assets.bitmapData('assets/icons/user.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/user.png', data);
            var data = Assets.bitmapData('assets/icons/mail.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/mail.png', data);
            var data = Assets.bitmapData('assets/icons/lock.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/lock.png', data);
            var data = Assets.bitmapData('assets/icons/power.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/power.png', data);
            var data = Assets.bitmapData('assets/icons/calendar.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/calendar.png', data);
            var data = Assets.bitmapData('assets/icons/gear.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/gear.png', data);
            var data = Assets.bitmapData('assets/icons/bookmark.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/bookmark.png', data);
            var data = Assets.bitmapData('assets/icons/exit.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/exit.png', data);
            var data = Assets.bitmapData('assets/icons/trash.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/trash.png', data);
            var data = Assets.bitmapData('assets/icons/folder.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/folder.png', data);
            var data = Assets.bitmapData('assets/icons/bubble.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/bubble.png', data);
            var data = Assets.bitmapData('assets/icons/export.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/export.png', data);
            var data = Assets.bitmapData('assets/icons/calendar-solid.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/calendar-solid.png', data);
            var data = Assets.bitmapData('assets/icons/star.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/star.png', data);
            var data = Assets.bitmapData('assets/icons/star-2.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/star-2.png', data);
            var data = Assets.bitmapData('assets/icons/credit-card.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/credit-card.png', data);
            var data = Assets.bitmapData('assets/icons/clip.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/clip.png', data);
            var data = Assets.bitmapData('assets/icons/link.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/link.png', data);
            var data = Assets.bitmapData('assets/icons/tag.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/tag.png', data);
            var data = Assets.bitmapData('assets/icons/document.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/document.png', data);
            var data = Assets.bitmapData('assets/icons/image.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/image.png', data);
            var data = Assets.bitmapData('assets/icons/facebook.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/facebook.png', data);
            var data = Assets.bitmapData('assets/icons/youtube.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/youtube.png', data);
            var data = Assets.bitmapData('assets/icons/vimeo.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/vimeo.png', data);
            var data = Assets.bitmapData('assets/icons/twitter.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/twitter.png', data);
            var data = Assets.bitmapData('assets/icons/spotify.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/spotify.png', data);
            var data = Assets.bitmapData('assets/icons/skype.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/skype.png', data);
            var data = Assets.bitmapData('assets/icons/pinterest.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/pinterest.png', data);
            var data = Assets.bitmapData('assets/icons/path.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/path.png', data);
            var data = Assets.bitmapData('assets/icons/linkedin.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/linkedin.png', data);
            var data = Assets.bitmapData('assets/icons/google-plus.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/google-plus.png', data);
            var data = Assets.bitmapData('assets/icons/dribbble.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/dribbble.png', data);
            var data = Assets.bitmapData('assets/icons/behance.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/behance.png', data);
            var data = Assets.bitmapData('assets/icons/stumbleupon.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/stumbleupon.png', data);
            var data = Assets.bitmapData('assets/icons/yelp.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/yelp.png', data);
            var data = Assets.bitmapData('assets/icons/wordpress.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/wordpress.png', data);
            var data = Assets.bitmapData('assets/icons/windows-8.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/windows-8.png', data);
            var data = Assets.bitmapData('assets/icons/vine.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/vine.png', data);
            var data = Assets.bitmapData('assets/icons/tumblr.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/tumblr.png', data);
            var data = Assets.bitmapData('assets/icons/paypal.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/paypal.png', data);
            var data = Assets.bitmapData('assets/icons/lastfm.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/lastfm.png', data);
            var data = Assets.bitmapData('assets/icons/instagram.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/instagram.png', data);
            var data = Assets.bitmapData('assets/icons/html5.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/html5.png', data);
            var data = Assets.bitmapData('assets/icons/github.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/github.png', data);
            var data = Assets.bitmapData('assets/icons/foursquare.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/foursquare.png', data);
            var data = Assets.bitmapData('assets/icons/dropbox.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/dropbox.png', data);
            var data = Assets.bitmapData('assets/icons/android.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/android.png', data);
            var data = Assets.bitmapData('assets/icons/apple.png');
            FlatUITheme.loadedBitmaps.set('assets/icons/apple.png', data);

            onReady();
        #else
            onReady();
        #end
    }


    static public function triangleUp (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/triangle-up.png', size, color);
    static public function triangleDown (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/triangle-down.png', size, color);
    static public function triangleUpSmall (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/triangle-up-small.png', size, color);
    static public function triangleDownSmall (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/triangle-down-small.png', size, color);
    static public function triangleLeftLarge (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/triangle-left-large.png', size, color);
    static public function triangleRightLarge (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/triangle-right-large.png', size, color);
    static public function arrowLeft (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/arrow-left.png', size, color);
    static public function arrowRight (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/arrow-right.png', size, color);
    static public function plus (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/plus.png', size, color);
    static public function cross (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/cross.png', size, color);
    static public function check (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/check.png', size, color);
    static public function radioUnchecked (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/radio-unchecked.png', size, color);
    static public function radioChecked (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/radio-checked.png', size, color);
    static public function checkboxUnchecked (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/checkbox-unchecked.png', size, color);
    static public function checkboxChecked (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/checkbox-checked.png', size, color);
    static public function infoCircle (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/info-circle.png', size, color);
    static public function alertCircle (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/alert-circle.png', size, color);
    static public function questionCircle (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/question-circle.png', size, color);
    static public function checkCircle (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/check-circle.png', size, color);
    static public function crossCircle (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/cross-circle.png', size, color);
    static public function plusCircle (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/plus-circle.png', size, color);
    static public function pause (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/pause.png', size, color);
    static public function play (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/play.png', size, color);
    static public function volume (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/volume.png', size, color);
    static public function mute (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/mute.png', size, color);
    static public function resize (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/resize.png', size, color);
    static public function list (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list.png', size, color);
    static public function listThumbnailed (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list-thumbnailed.png', size, color);
    static public function listSmallThumbnails (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list-small-thumbnails.png', size, color);
    static public function listLargeThumbnails (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list-large-thumbnails.png', size, color);
    static public function listNumbered (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list-numbered.png', size, color);
    static public function listColumned (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list-columned.png', size, color);
    static public function listBulleted (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/list-bulleted.png', size, color);
    static public function window (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/window.png', size, color);
    static public function windows (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/windows.png', size, color);
    static public function loop (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/loop.png', size, color);
    static public function cmd (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/cmd.png', size, color);
    static public function mic (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/mic.png', size, color);
    static public function heart (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/heart.png', size, color);
    static public function location (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/location.png', size, color);
    static public function newIcon (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/new.png', size, color);
    static public function video (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/video.png', size, color);
    static public function photo (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/photo.png', size, color);
    static public function time (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/time.png', size, color);
    static public function eye (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/eye.png', size, color);
    static public function chat (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/chat.png', size, color);
    static public function home (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/home.png', size, color);
    static public function upload (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/upload.png', size, color);
    static public function search (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/search.png', size, color);
    static public function user (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/user.png', size, color);
    static public function mail (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/mail.png', size, color);
    static public function lock (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/lock.png', size, color);
    static public function power (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/power.png', size, color);
    static public function calendar (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/calendar.png', size, color);
    static public function gear (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/gear.png', size, color);
    static public function bookmark (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/bookmark.png', size, color);
    static public function exit (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/exit.png', size, color);
    static public function trash (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/trash.png', size, color);
    static public function folder (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/folder.png', size, color);
    static public function bubble (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/bubble.png', size, color);
    static public function export (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/export.png', size, color);
    static public function calendarSolid (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/calendar-solid.png', size, color);
    static public function star (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/star.png', size, color);
    static public function star2 (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/star-2.png', size, color);
    static public function creditCard (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/credit-card.png', size, color);
    static public function clip (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/clip.png', size, color);
    static public function link (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/link.png', size, color);
    static public function tag (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/tag.png', size, color);
    static public function document (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/document.png', size, color);
    static public function image (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/image.png', size, color);
    static public function facebook (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/facebook.png', size, color);
    static public function youtube (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/youtube.png', size, color);
    static public function vimeo (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/vimeo.png', size, color);
    static public function twitter (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/twitter.png', size, color);
    static public function spotify (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/spotify.png', size, color);
    static public function skype (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/skype.png', size, color);
    static public function pinterest (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/pinterest.png', size, color);
    static public function path (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/path.png', size, color);
    static public function linkedin (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/linkedin.png', size, color);
    static public function googlePlus (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/google-plus.png', size, color);
    static public function dribbble (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/dribbble.png', size, color);
    static public function behance (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/behance.png', size, color);
    static public function stumbleupon (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/stumbleupon.png', size, color);
    static public function yelp (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/yelp.png', size, color);
    static public function wordpress (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/wordpress.png', size, color);
    static public function windows8 (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/windows-8.png', size, color);
    static public function vine (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/vine.png', size, color);
    static public function tumblr (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/tumblr.png', size, color);
    static public function paypal (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/paypal.png', size, color);
    static public function lastfm (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/lastfm.png', size, color);
    static public function instagram (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/instagram.png', size, color);
    static public function html5 (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/html5.png', size, color);
    static public function github (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/github.png', size, color);
    static public function foursquare (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/foursquare.png', size, color);
    static public function dropbox (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/dropbox.png', size, color);
    static public function android (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/android.png', size, color);
    static public function apple (size:Int = -1, color:Int = -1) return __createIcon('assets/icons/apple.png', size, color);


    /**
     * Description
     */
    static private function __createIcon (assetPath:String, size:Int, color:Int) : ScaleFit
    {
        var bmp = new Bmp();
        bmp.bitmapData = FlatUITheme.loadedBitmaps.get(assetPath);
        bmp.smooth = true;

        if (size == -1) size = FlatUITheme.DEFAULT_ICO_SIZE;
        if (color != -1) {
            setColor(bmp, color);
        }

        var icon = new ScaleFit();
        icon.width.dip  = size;
        icon.height.dip = size;

        icon.addChild(bmp);

        return icon;
    }

}//class Icons