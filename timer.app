import { useState, useEffect, useRef } from 'react';

export default function TimerApp() {
  const [minutes, setMinutes] = useState(5);
  const [seconds, setSeconds] = useState(0);
  const [isRunning, setIsRunning] = useState(false);
  const [inputMinutes, setInputMinutes] = useState('5');
  const intervalRef = useRef(null);

  useEffect(() => {
    if (isRunning) {
      intervalRef.current = setInterval(() => {
        setSeconds(prev => {
          if (prev === 0) {
            setMinutes(prevMin => {
              if (prevMin === 0) {
                setIsRunning(false);
                playSound();
                return 0;
              }
              return prevMin - 1;
            });
            return 59;
          }
          return prev - 1;
        });
      }, 1000);
    } else {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    }

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [isRunning]);

  const playSound = () => {
    const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBTO');
    audio.play().catch(() => {});
  };

  const handleStart = () => {
    setIsRunning(true);
  };

  const handlePause = () => {
    setIsRunning(false);
  };

  const handleReset = () => {
    setIsRunning(false);
    const mins = parseInt(inputMinutes) || 5;
    setMinutes(mins);
    setSeconds(0);
  };

  const handleSetTime = () => {
    const mins = parseInt(inputMinutes) || 5;
    setMinutes(mins);
    setSeconds(0);
    setIsRunning(false);
  };

  const isFinished = minutes === 0 && seconds === 0;

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl shadow-2xl p-8 w-full max-w-md">
        <h1 className="text-3xl font-bold text-center mb-8 text-indigo-900">
          タイマー
        </h1>

        <div className={`text-7xl font-mono font-bold text-center mb-8 transition-colors ${
          isFinished ? 'text-red-500 animate-pulse' : 'text-gray-800'
        }`}>
          {String(minutes).padStart(2, '0')}:{String(seconds).padStart(2, '0')}
        </div>

        {isFinished && (
          <div className="text-center text-red-500 font-bold text-xl mb-6 animate-bounce">
            時間です！
          </div>
        )}

        <div className="flex gap-3 mb-6">
          {!isRunning ? (
            <button
              onClick={handleStart}
              className="flex-1 bg-green-500 hover:bg-green-600 text-white font-bold py-4 px-6 rounded-xl transition-colors shadow-lg"
            >
              スタート
            </button>
          ) : (
            <button
              onClick={handlePause}
              className="flex-1 bg-yellow-500 hover:bg-yellow-600 text-white font-bold py-4 px-6 rounded-xl transition-colors shadow-lg"
            >
              一時停止
            </button>
          )}
          <button
            onClick={handleReset}
            className="flex-1 bg-red-500 hover:bg-red-600 text-white font-bold py-4 px-6 rounded-xl transition-colors shadow-lg"
          >
            リセット
          </button>
        </div>

        <div className="border-t pt-6">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            時間設定（分）
          </label>
          <div className="flex gap-3">
            <input
              type="number"
              min="1"
              max="99"
              value={inputMinutes}
              onChange={(e) => setInputMinutes(e.target.value)}
              className="flex-1 border-2 border-gray-300 rounded-lg px-4 py-3 text-lg focus:outline-none focus:border-indigo-500"
              disabled={isRunning}
            />
            <button
              onClick={handleSetTime}
              disabled={isRunning}
              className="bg-indigo-500 hover:bg-indigo-600 disabled:bg-gray-300 text-white font-bold py-3 px-6 rounded-lg transition-colors"
            >
              設定
            </button>
          </div>
        </div>

        <div className="mt-6 flex gap-2">
          {[1, 3, 5, 10, 15].map(min => (
            <button
              key={min}
              onClick={() => {
                setInputMinutes(String(min));
                setMinutes(min);
                setSeconds(0);
                setIsRunning(false);
              }}
              disabled={isRunning}
              className="flex-1 bg-gray-200 hover:bg-gray-300 disabled:bg-gray-100 text-gray-700 font-semibold py-2 px-3 rounded-lg text-sm transition-colors"
            >
              {min}分
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
