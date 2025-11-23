import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

// Controller untuk mengontrol playlist dari luar
// AudioPlayer dikelola di sini agar persistent
class MusicPlaylistController extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _showPlaylist = false; // Tambahan untuk toggle playlist
  bool _isMuted = false; // Tambahan untuk mute
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  List<PlaylistItem> _playlist = [];

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get showPlaylist => _showPlaylist;
  bool get isMuted => _isMuted;
  int get currentIndex => _currentIndex;
  Duration get duration => _duration;
  Duration get position => _position;
  List<PlaylistItem> get playlist => _playlist;
  PlaylistItem? get currentTrack =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;

  void initialize(List<PlaylistItem> playlist) {
    if (_audioPlayer != null) return; // Sudah di-init

    _playlist = playlist;
    _audioPlayer = AudioPlayer();
    _setupListeners();
  }

  void togglePlaylistView() {
    _showPlaylist = !_showPlaylist;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _audioPlayer?.setVolume(_isMuted ? 0.0 : 1.0);
    notifyListeners();
  }

  void _setupListeners() {
    _audioPlayer?.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer?.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer?.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      if (state == PlayerState.playing) {
        _isLoading = false;
      }
      notifyListeners();
    });

    _audioPlayer?.onPlayerComplete.listen((_) {
      playNext();
    });
  }

  Future<void> playTrack(int index) async {
    if (_audioPlayer == null || index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    _isLoading = true;
    notifyListeners();

    try {
      await _audioPlayer?.stop();
      final path = _playlist[index].path;
      print('🎵 Playing: $path');
      await _audioPlayer?.play(AssetSource(path));
      _isInitialized = true;
      print('✅ Audio started');
    } catch (e) {
      print('❌ Error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void play() {
    if (!_isPlaying) {
      if (!_isInitialized) {
        playTrack(_currentIndex);
      } else {
        _audioPlayer?.resume();
      }
    }
  }

  void pause() {
    if (_isPlaying) {
      _audioPlayer?.pause();
    }
  }

  void toggle() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void playNext() {
    int nextIndex = (_currentIndex + 1) % _playlist.length;
    playTrack(nextIndex);
  }

  void playPrevious() {
    int prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    playTrack(prevIndex);
  }

  void seek(Duration position) {
    _audioPlayer?.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
    super.dispose();
  }
}

// Widget untuk menampilkan playlist UI
class MusicPlaylist extends StatelessWidget {
  final MusicPlaylistController controller;
  final Color? primaryColor;
  final Color? backgroundColor;

  const MusicPlaylist({
    Key? key,
    required this.controller,
    this.primaryColor,
    this.backgroundColor,
  }) : super(key: key);

  Color get _primaryColor => primaryColor ?? Color(0xFFD4AF37);
  Color get _backgroundColor => backgroundColor ?? Color(0xFF1A1A1A);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.playlist.isEmpty) return SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMiniPlayer(),
            // Tampilkan daftar lagu jika showPlaylist true
            if (controller.showPlaylist) ...[
              SizedBox(height: 8),
              _buildPlaylistView(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMiniPlayer() {
    final currentTrack = controller.currentTrack;
    if (currentTrack == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Baris 1: Icon + Info Lagu
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.music_note, color: _primaryColor, size: 18),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentTrack.title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1),
                    Text(
                      currentTrack.artist,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          // Progress Bar
          Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 8),
                  activeTrackColor: _primaryColor,
                  inactiveTrackColor: _primaryColor.withOpacity(0.2),
                  thumbColor: _primaryColor,
                  overlayColor: _primaryColor.withOpacity(0.2),
                ),
                child: Slider(
                  value: controller.position.inSeconds.toDouble().clamp(
                    0,
                    controller.duration.inSeconds.toDouble().clamp(
                      1,
                      double.infinity,
                    ),
                  ),
                  max: controller.duration.inSeconds.toDouble().clamp(
                    1.0,
                    double.infinity,
                  ),
                  onChanged: (v) =>
                      controller.seek(Duration(seconds: v.toInt())),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(controller.position),
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      _formatDuration(controller.duration),
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          // Baris 2: Kontrol Musik
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Sebelumnya',
                child: IconButton(
                  icon: Icon(Icons.skip_previous, color: _primaryColor),
                  onPressed: controller.playPrevious,
                  iconSize: 22,
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ),
              SizedBox(width: 6),
              controller.isLoading
                  ? SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(_primaryColor),
                      ),
                    )
                  : Tooltip(
                      message: controller.isPlaying ? 'Jeda' : 'Putar',
                      child: IconButton(
                        icon: Icon(
                          controller.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: _primaryColor,
                        ),
                        onPressed: controller.toggle,
                        iconSize: 34,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
              SizedBox(width: 6),
              Tooltip(
                message: 'Selanjutnya',
                child: IconButton(
                  icon: Icon(Icons.skip_next, color: _primaryColor),
                  onPressed: controller.playNext,
                  iconSize: 22,
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ),
              SizedBox(width: 8),
              Tooltip(
                message: controller.isMuted ? 'Suarakan' : 'Bisukan',
                child: IconButton(
                  icon: Icon(
                    controller.isMuted ? Icons.volume_off : Icons.volume_up,
                    color: _primaryColor,
                  ),
                  onPressed: controller.toggleMute,
                  iconSize: 20,
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ),
              SizedBox(width: 2),
              Tooltip(
                message: controller.showPlaylist
                    ? 'Tutup Daftar'
                    : 'Daftar Lagu',
                child: IconButton(
                  icon: Icon(
                    controller.showPlaylist
                        ? Icons.keyboard_arrow_up
                        : Icons.queue_music,
                    color: _primaryColor,
                  ),
                  onPressed: controller.togglePlaylistView,
                  iconSize: 20,
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistView() {
    return Container(
      constraints: BoxConstraints(maxHeight: 200), // Batasi tinggi
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header compact
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.queue_music, color: _primaryColor, size: 16),
                SizedBox(width: 8),
                Text(
                  '${controller.playlist.length} lagu',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // List dengan scroll
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.playlist.length,
              itemBuilder: (context, index) {
                final item = controller.playlist[index];
                final isCurrentTrack = index == controller.currentIndex;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.playTrack(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentTrack
                            ? _primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          // Nomor atau icon
                          SizedBox(
                            width: 20,
                            child: isCurrentTrack
                                ? Icon(
                                    Icons.equalizer,
                                    color: _primaryColor,
                                    size: 16,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          SizedBox(width: 10),
                          // Info lagu
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: isCurrentTrack
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isCurrentTrack
                                        ? _primaryColor
                                        : Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item.artist,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Durasi
                          if (item.duration != null)
                            Text(
                              item.duration!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Tombol musik floating yang simple
class MusicFloatingButton extends StatelessWidget {
  final MusicPlaylistController controller;
  final VoidCallback? onTap;
  final bool showPlaylist;

  const MusicFloatingButton({
    Key? key,
    required this.controller,
    this.onTap,
    this.showPlaylist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return GestureDetector(
          onTap: onTap ?? controller.toggle,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A).withOpacity(0.9),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color(0xFFD4AF37).withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              showPlaylist
                  ? Icons.close
                  : (controller.isPlaying ? Icons.music_note : Icons.music_off),
              color: Color(0xFFD4AF37),
              size: 24,
            ),
          ),
        );
      },
    );
  }
}

class PlaylistItem {
  final String title;
  final String artist;
  final String path;
  final String? duration;

  const PlaylistItem({
    required this.title,
    required this.artist,
    required this.path,
    this.duration,
  });
}
