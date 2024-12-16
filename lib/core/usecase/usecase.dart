// Usecase: Nơi THỰC THI các hoạt động chính của Entity nằm trong Domain
abstract class UseCase<Type, Params> {

  //Type: Method trả về generic class kiểu động
  //Params: kiểu dữ liệu của tham số mà usecase nhận vào
  Future<Type> call({Params params});
}